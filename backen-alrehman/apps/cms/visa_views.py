"""
Visa API Views
Fetches detail data from production web for latest prices/durations.
List from DB, detail from web with DB fallback.
"""
import re
import json
import logging
from html import unescape
from urllib.request import Request, urlopen
from urllib.error import URLError
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.core.cache import cache
from apps.cms.models import ContentPages
from apps.umrah.models import CmsVisaPackages

logger = logging.getLogger(__name__)

PRODUCTION_BASE = 'https://www.rehmantravel.com'
CACHE_TTL = 300  # 5 minutes


def _fetch_web_page(url_path):
    """Fetch Inertia page data from production web"""
    cache_key = f'web_{url_path.replace("/", "_")}'
    cached = cache.get(cache_key)
    if cached:
        return cached

    url = f'{PRODUCTION_BASE}/{url_path}'
    req = Request(url, headers={
        'User-Agent': 'Mozilla/5.0 (Linux; Android 10)',
        'Accept': 'text/html',
    })
    try:
        with urlopen(req, timeout=15) as resp:
            body = resp.read().decode('utf-8', errors='replace')
    except (URLError, Exception) as e:
        logger.error(f'Failed to fetch {url}: {e}')
        return None

    match = re.search(r'data-page="([^"]*)"', body)
    if not match:
        return None

    raw = match.group(1).replace('&quot;', '"').replace('&amp;', '&').replace('&#039;', "'")
    try:
        page_data = json.loads(raw)
    except json.JSONDecodeError:
        return None

    result = page_data.get('props', {})
    cache.set(cache_key, result, CACHE_TTL)
    return result


def _strip_html(html_str):
    """Strip HTML tags and decode entities"""
    if not html_str:
        return ''
    text = unescape(str(html_str))
    text = re.sub(r'<[^>]+>', '', text)
    text = text.replace('&nbsp;', ' ').replace('&amp;', '&')
    return re.sub(r'\s+', ' ', text).strip()


class VisaViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Public API for Visa data

    Endpoints:
    - GET /api/visa/ - List all active visas
    - GET /api/visa/{id}/ - Get visa details by ID
    - GET /api/visa/by-url/?url=visa/singapore - Get visa by URL slug
    """
    permission_classes = [AllowAny]
    queryset = ContentPages.objects.none()

    def get_queryset(self):
        return ContentPages.objects.filter(
            parentid=4,
            status=1
        ).order_by('sequence')

    def list(self, request):
        queryset = self.get_queryset()

        visas = []
        for content_page in queryset:
            try:
                visa_package = CmsVisaPackages.objects.get(cmscontentid=content_page.id)
            except CmsVisaPackages.DoesNotExist:
                visa_package = None

            visas.append({
                'id': content_page.id,
                'packageTitle': content_page.packagetitle,
                'urlLink': content_page.urllink,
                'metaTitle': content_page.metatitle,
                'metaDescription': content_page.metadescription,
                'cardImage': content_page.cardimage,
                'countryName': visa_package.countryname if visa_package else None,
                'packageUrl': visa_package.packageurl if visa_package else None,
            })

        return Response(visas)

    def retrieve(self, request, pk=None):
        try:
            content_page = self.get_queryset().get(pk=pk)
        except ContentPages.DoesNotExist:
            return Response({'error': 'Visa not found'}, status=status.HTTP_404_NOT_FOUND)

        return self._build_response(content_page.urllink, content_page)

    @action(detail=False, methods=['get'], url_path='by-url')
    def get_by_url(self, request):
        url_link = request.query_params.get('url')
        if not url_link:
            return Response({'error': 'URL parameter is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            content_page = self.get_queryset().get(urllink=url_link)
        except ContentPages.DoesNotExist:
            return Response({'error': 'Visa not found'}, status=status.HTTP_404_NOT_FOUND)

        return self._build_response(url_link, content_page)

    def _build_response(self, url_link, content_page):
        """Build visa detail — try production web first, fallback to DB"""

        # Try fetching from production web for latest data
        web_props = _fetch_web_page(url_link)
        web_durations = []
        web_details = None

        if web_props:
            visa_packages = web_props.get('visaPackages', [])
            if isinstance(visa_packages, list) and visa_packages:
                pkg = visa_packages[0]
                web_details = pkg.get('visaDetails', {})
                raw_durations = pkg.get('visaDuration', [])
                for d in raw_durations:
                    if d.get('durationStatus') != 1:
                        continue
                    web_durations.append({
                        'id': d.get('id'),
                        'visaTitle': d.get('visaTitle', ''),
                        'visaPrice': d.get('visaPrice', ''),
                        'currency': d.get('currency', ''),
                        'numEntries': d.get('numEntries', ''),
                        'duration': d.get('duration', ''),
                        'validity': d.get('validity', ''),
                        'visaType': d.get('visaType', ''),
                        'visaIncludes': _strip_html(d.get('visaIncludes', '')),
                    })

        # Use web data for details if available
        if web_details:
            details_data = {
                'id': web_details.get('id', content_page.id),
                'parentId': content_page.parentid.id if content_page.parentid else None,
                'packageTitle': web_details.get('packageTitle', content_page.packagetitle),
                'urlLink': web_details.get('urlLink', content_page.urllink),
                'metaTitle': web_details.get('metaTitle', content_page.metatitle),
                'metaDescription': web_details.get('metaDescription', content_page.metadescription),
                'description': unescape(web_details.get('description', '') or ''),
                'shortDescription': unescape(web_details.get('shortDescription', '') or '') or None,
                'cardImage': web_details.get('cardImage', content_page.cardimage),
                'bannerImage': web_details.get('bannerImage', content_page.bannerimage),
                'includes': web_details.get('includes'),
                'excludes': web_details.get('excludes'),
                'documentsRequired': web_details.get('documentsRequired'),
                'price': web_details.get('price', content_page.price),
                'currencyType': web_details.get('currencyType', content_page.currencytype),
                'status': web_details.get('status', content_page.status),
            }
        else:
            details_data = {
                'id': content_page.id,
                'parentId': content_page.parentid.id if content_page.parentid else None,
                'packageTitle': content_page.packagetitle,
                'urlLink': content_page.urllink,
                'metaTitle': content_page.metatitle,
                'metaDescription': content_page.metadescription,
                'description': content_page.description,
                'shortDescription': content_page.shortdescription,
                'cardImage': content_page.cardimage,
                'bannerImage': content_page.bannerimage,
                'includes': content_page.includes,
                'excludes': content_page.excludes,
                'documentsRequired': content_page.documentsrequired,
                'price': content_page.price,
                'status': content_page.status,
            }

        # Get visa package info from DB
        try:
            visa_package = CmsVisaPackages.objects.get(cmscontentid=content_page.id)
        except CmsVisaPackages.DoesNotExist:
            visa_package = None

        # If no web durations, fallback to DB
        if not web_durations:
            from apps.umrah.models import CmsVisaDurations
            if visa_package:
                db_durations = CmsVisaDurations.objects.filter(visaid=visa_package.id, durationstatus=1)
                for d in db_durations:
                    web_durations.append({
                        'id': d.id,
                        'visaTitle': d.visatitle,
                        'visaPrice': d.visaprice,
                        'currency': d.currency,
                        'numEntries': d.numentries,
                        'duration': d.duration,
                        'validity': d.validity,
                        'visaType': d.visatype,
                        'visaIncludes': _strip_html(d.visaincludes),
                    })

        return Response({
            'visaDetails': details_data,
            'visaPackage': {
                'countryName': visa_package.countryname if visa_package else None,
                'packageUrl': visa_package.packageurl if visa_package else None,
                'tourUrl': visa_package.toururl if visa_package else None,
            } if visa_package else None,
            'visaDurations': web_durations,
        })
