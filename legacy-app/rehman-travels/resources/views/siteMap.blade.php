<?php echo '<?xml version="1.0" encoding="UTF-8"?>'; ?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>https://www.rehmantravel.com</loc>
        <lastmod><?php echo date('Y-m-d\TH:i:s+00:00'); ?></lastmod>
    </url>
    <url>
      <loc>https://www.rehmantravel.com/contactUs</loc>
      <lastmod>2023-08-10T11:57:27+00:00</lastmod>
    </url>
    <url>
      <loc>https://www.rehmantravel.com/pakistantours</loc>
      <lastmod>2024-09-16T09:50:56+00:00</lastmod>
    </url>
    <url>
      <loc>https://www.rehmantravel.com/visa</loc>
      <lastmod>2025-08-29T06:35:00+00:00</lastmod>
    </url>
    @foreach ($contents as $content)
    <url>
        <loc><?php echo $content['urlLink']; ?></loc>
        <lastmod><?php echo $content['update_at']; ?></lastmod>
    </url>
    @endforeach
</urlset>