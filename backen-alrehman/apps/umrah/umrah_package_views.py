"""
Umrah Packages API Views
Public endpoints for Umrah package data retrieval
HTML tables are parsed into structured JSON for mobile app rendering
"""
import re
from html.parser import HTMLParser
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from apps.cms.models import ContentPages


# ── HTML Parser Utilities ──

def _clean_html_structure(html):
    """Remove figure wrappers and unwrap single-cell wrapper tables"""
    c = html
    c = re.sub(r'<figure[^>]*>', '', c, flags=re.IGNORECASE)
    c = re.sub(r'</figure>', '', c, flags=re.IGNORECASE)
    c = re.sub(
        r'<table>\s*<tbody>\s*<tr>\s*<td>\s*((?:<table[\s\S]*?</table>\s*)+)\s*</td>\s*</tr>\s*</tbody>\s*</table>',
        r'\1',
        c, flags=re.IGNORECASE
    )
    return c


class _TableParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.tables = []
        self.current_table = None
        self.current_row = None
        self.current_cell = ''
        self.in_cell = False
        self.is_header = False

    def handle_starttag(self, tag, attrs):
        if tag == 'table':
            self.current_table = {'rows': []}
        elif tag == 'thead':
            self.is_header = True
        elif tag == 'tr' and self.current_table is not None:
            self.current_row = {'cells': [], 'isHeader': self.is_header}
        elif tag in ('td', 'th') and self.current_row is not None:
            self.in_cell = True
            self.current_cell = ''
            if tag == 'th':
                self.current_row['isHeader'] = True

    def handle_endtag(self, tag):
        if tag == 'table' and self.current_table is not None:
            if self.current_table['rows']:
                self.tables.append(self.current_table)
            self.current_table = None
        elif tag == 'thead':
            self.is_header = False
        elif tag == 'tr' and self.current_row is not None and self.current_table is not None:
            self.current_table['rows'].append(self.current_row)
            self.current_row = None
        elif tag in ('td', 'th') and self.in_cell:
            text = re.sub(r'\s+', ' ', self.current_cell).strip()
            if self.current_row is not None:
                self.current_row['cells'].append(text)
            self.in_cell = False

    def handle_data(self, data):
        if self.in_cell:
            self.current_cell += data

    def handle_entityref(self, name):
        if self.in_cell:
            entities = {
                'nbsp': ' ', 'amp': '&', 'lt': '<', 'gt': '>',
                'rsquo': '\u2019', 'ldquo': '\u201c', 'rdquo': '\u201d',
            }
            self.current_cell += entities.get(name, '')


def _strip_tags(html):
    text = re.sub(r'<[^>]+>', '', html)
    text = text.replace('&nbsp;', ' ').replace('&amp;', '&').replace('&rsquo;', '\u2019')
    return re.sub(r'\s+', ' ', text).strip()


def parse_html_content(html):
    """Parse HTML into structured sections: text paragraphs + tables"""
    if not html:
        return []

    cleaned = _clean_html_structure(html)
    sections = []

    parts = re.split(r'(<table[\s\S]*?</table>)', cleaned, flags=re.IGNORECASE)

    for part in parts:
        if '<table' in part.lower():
            parser = _TableParser()
            parser.feed(part)
            for tbl in parser.tables:
                table_data = {'type': 'table', 'headers': [], 'rows': []}
                for row in tbl['rows']:
                    cells = row['cells']
                    if all(c.strip() == '' for c in cells):
                        continue
                    if row.get('isHeader'):
                        table_data['headers'].append(cells)
                    else:
                        table_data['rows'].append(cells)
                if table_data['headers'] or table_data['rows']:
                    sections.append(table_data)
        else:
            text = _strip_tags(part)
            if text and len(text) > 1:
                sections.append({'type': 'text', 'content': text})

    return sections


def parse_description_html(html):
    """Parse description HTML — strip tags, return clean text paragraphs"""
    if not html:
        return []

    cleaned = re.sub(r'<div[^>]*>', '', html, flags=re.IGNORECASE)
    cleaned = re.sub(r'</div>', '', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r'<span[^>]*>', '', cleaned, flags=re.IGNORECASE)
    cleaned = re.sub(r'</span>', '', cleaned, flags=re.IGNORECASE)

    sections = []
    block_pattern = re.compile(
        r'<(h[1-6]|p)(?:\s[^>]*)?>(.+?)</\1>',
        re.DOTALL | re.IGNORECASE
    )
    for match in block_pattern.finditer(cleaned):
        tag = match.group(1).lower()
        text = _strip_tags(match.group(2)).strip()
        if not text:
            continue
        if tag.startswith('h'):
            sections.append({'type': 'heading', 'content': text})
        else:
            sections.append({'type': 'text', 'content': text})

    return sections


# ── API ViewSet ──

class UmrahPackageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Public API for Umrah Packages

    Endpoints:
    - GET /api/umrah/packages/              - List all active umrah packages
    - GET /api/umrah/packages/{id}/         - Get package details by ID
    - GET /api/umrah/packages/by-url/?url=umrah-packages/executive - Get by URL slug
    """
    permission_classes = [AllowAny]
    queryset = ContentPages.objects.none()

    def get_queryset(self):
        return ContentPages.objects.filter(
            parentid=2,
            status=1
        ).order_by('sequence')

    def list(self, request):
        queryset = self.get_queryset()

        packages = []
        for page in queryset:
            packages.append({
                'id': page.id,
                'packageTitle': page.packagetitle,
                'urlLink': page.urllink,
                'metaTitle': page.metatitle,
                'cardImage': page.cardimage,
                'bannerImage': page.bannerimage,
                'price': page.price,
                'currencyType': page.currencytype,
                'shortDescription': page.shortdescription,
                'categories': page.categories,
                'sequence': page.sequence,
            })

        return Response(packages)

    def retrieve(self, request, pk=None):
        try:
            content_page = self.get_queryset().get(pk=pk)
        except ContentPages.DoesNotExist:
            return Response(
                {'error': 'Umrah package not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        return self._build_detail(content_page)

    @action(detail=False, methods=['get'], url_path='by-url')
    def get_by_url(self, request):
        url_link = request.query_params.get('url')
        if not url_link:
            return Response(
                {'error': 'URL parameter is required'},
                status=status.HTTP_400_BAD_REQUEST
            )
        try:
            content_page = self.get_queryset().get(urllink=url_link)
        except ContentPages.DoesNotExist:
            return Response(
                {'error': 'Umrah package not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        return self._build_detail(content_page)

    def _build_detail(self, page):
        """Build structured detail response with parsed HTML"""
        return Response({
            'packageDetails': {
                'id': page.id,
                'parentId': page.parentid.id if page.parentid else None,
                'packageTitle': page.packagetitle,
                'urlLink': page.urllink,
                'metaTitle': page.metatitle,
                'metaDescription': page.metadescription,
                'cardImage': page.cardimage,
                'bannerImage': page.bannerimage,
                'price': page.price,
                'currencyType': page.currencytype,
                'categories': page.categories,
                'status': page.status,
            },
            'overview': parse_html_content(page.shortdescription),
            'description': parse_description_html(page.description),
            'includes': parse_html_content(page.includes),
            'excludes': parse_html_content(page.excludes),
        })
