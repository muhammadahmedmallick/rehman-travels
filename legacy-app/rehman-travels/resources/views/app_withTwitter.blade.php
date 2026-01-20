<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0"/>
    <meta name="verify-reviews" content="$2y$10$svE4L1z49ENEDY1HjtS6Ye7fYMJNBkCX7AYDiX.pOXP8aQt0UTWKm">
    <meta name="google-site-verification" content="uUIzG62N4Rv7C_-fIqnFGpGPpp0bF2_ViqdF--eHCyE">
    <meta name="public" content="Public">
    <meta name="author" content="Abdul Rehman">
    <meta name="Robots" content="all">
    <meta head-key="language" content="English">
    <meta head-key="fb:admins" property="fb:admins" content="100064855023859"/>
    <meta head-key="og:locale" property="og:locale" content="en-us" />
    <meta head-key="og:type" property="og:type" content="website" />
    <meta head-key="og:site_name" property="og:site_name" content="Rehman Travels" />
    <?php if(isset($headerArr) || !empty($headerArr)): ?>
    <title> <?= $headerArr['title']; ?> </title>
    <meta head-key="description" type="description" content="<?= $headerArr['description']; ?>" />
    <meta head-key="og:title" property="og:title" content="<?= $headerArr['metaTitle']; ?>" />
    <meta head-key="og:description" property="og:description" content="<?= $headerArr['description']; ?>" />
    <meta head-key="og:url" property="og:url" content="<?= $headerArr['og:url']; ?>">
    <meta head-key="og:image" property="og:image" content="https://www.rehmantravel.com/<?= $headerArr['image']; ?>" />
    <meta head-key="og:image:secure_url" property="og:image:secure_url" content="https://www.rehmantravel.com/<?= $headerArr['og:image:secure_url']; ?>" />
    <meta head-key="og:image:type" property="og:image:type" content="image/png" />
    <meta head-key="og:image:width" property="og:image:width" content="400" />
    <meta head-key="og:image:height" property="og:image:height" content="300" />
    <meta head-key="og:image:alt" property="og:image:alt" content="<?= $headerArr['metaTitle']; ?>" />
    <meta head-key="twitter:site" name="twitter:site" content="@RehmanTravels"/>
    <meta head-key="twitter:creator" name="twitter:creator" content="@RehmanTravels"/> 
    <meta head-key="twitter:title" name="twitter:title" content="<?= $headerArr['metaTitle']; ?>"  />
    <meta head-key="twitter:description" name="twitter:description" content="<?= $headerArr['description']; ?>"/>
    <meta head-key="twitter:url" name="twitter:url" content="<?= $headerArr['description']; ?>" />
    <meta head-key="twitter:image" name="twitter:image" content="https://www.rehmantravel.com/<?= $headerArr['image']; ?>" />
    <meta head-key="twitter:card" name="twitter:card" content="summary_large_image" />
    <meta head-key="image" itemprop="image" content="https://www.rehmantravel.com/<?= $headerArr['image']; ?>"/>
    <?php endif; ?>
    <script>
        window.Laravel = {
            csrfToken: '{{ csrf_token() }}'
        }
    </script>
    <link rel="icon" type="image/x-icon" href="{{ url('favicon.ico')}}">
    <link rel="stylesheet" href="/assets/style.css"/>
    @routes
    @vite(['resources/js/app.js', "resources/js/Pages/{$page['component']}.vue"])
    <script type="application/ld+json">
        {
            "@context": "https://schema.org",
            "@type": "Organization",
            "url": "https://www.rehmantravel.com/",
            "name": "Rehman Group of Travels",
            "logo": "https://www.rehmantravel.com/assets/img/rgt-logo.png",
            "address": {
                "@type": "PostalAddress",
                "addressLocality": "Islamabad, Pakistan",
                "postalCode": "44000",
                "streetAddress": "Head Office 01 & 03, Allay Plaza, Near PIA Head Office, Fazl-e-Haq Road Blue Area"
            },
            "contactPoint": {
                "@type": "ContactPoint",
                "telephone": "+92-51-111-786-785",
                "contactType": "Customer service"
            }
        }, {
            "@context": "https://schema.org",
            "@type": "Website",
            "url": "https://www.rehmantravel.com/",
            "sameAs": [
                "https://www.facebook.com/rehmantravelofficial",
                "https://www.youtube.com/RehmanTravelsOfficial",
                "https://www.pinterest.com/rehmantravel",
                "https://twitter.com/rehmantravelcom",
                "https://www.instagram.com/rehmantravel/"
            ]
        }, {
            "@context": "https://schema.org",
            "@type": "TravelAgency",
            "name": "Rehman Group of Travels",
            "url": "https://www.rehmantravel.com/",
            "paymentAccepted": "Cash, Credit Card, Jazz Cash, Bank Online",
            "logo": "https://www.rehmantravel.com/assets/img/rgt-logo.png",
            "description": "Get Cheap Flights, Hotel Bookings, Domestic & International Tours, Umrah Packages, Visit Visa, Corporate Deals, Travel Insurance & Rent a Car. Amazing Flight Deals.",
            "openingHours": "Mo,Tu,We,Th,Fr,Sa,Su 09:00-24:00",
            "telephone": "+9251111786785",
            "priceRange": "$$$",
            "image": "https://www.rehmantravel.com/assets/img/rgt-logo.png",
            "address": {
                "@type": "PostalAddress",
                "addressLocality": "Islamabad, Pakistan",
                "postalCode": "44000",
                "streetAddress": "Head Office 01 & 03, Allay Plaza, Near PIA Head Office, Fazl-e-Haq Road Blue Area"
            }
        }
    </script>
    
    <!-- Google Tag Manager -->
    <script>(function (w, d, s, l, i) {
                w[l] = w[l] || [];
                w[l].push({'gtm.start':
                            new Date().getTime(), event: 'gtm.js'});
                var f = d.getElementsByTagName(s)[0],
                        j = d.createElement(s), dl = l != 'dataLayer' ? '&l=' + l : '';
                j.async = true;
                j.src =
                        'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
                f.parentNode.insertBefore(j, f);
            })(window, document, 'script', 'dataLayer', 'GTM-W4WB2DP');</script>
    <!-- End Google Tag Manager -->
    
    <!-- Facebook Pixel Code -->
    <script> !function(f,b,e,v,n,t,s) {if(f.fbq)return;n=f.fbq=function(){n.callMethod? n.callMethod.apply(n,arguments):n.queue.push(arguments)}; if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0'; n.queue=[];t=b.createElement(e);t.async=!0; t.src=v;s=b.getElementsByTagName(e)[0]; s.parentNode.insertBefore(t,s)}(window, document,'script', 'https://connect.facebook.net/en_US/fbevents.js'); fbq('init', '100723900653355'); fbq('track', 'PageView'); </script> <noscript><img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=100723900653355&ev=PageView&noscript=1" /></noscript>
    
    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-W4WB2DP" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    
    <!-- Global site tag (gtag.js) - Google Ads: 858080073 -->
    <script async="" src="https://www.googletagmanager.com/gtag/js?id=AW-858080073"></script>
    
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async="" src="https://www.googletagmanager.com/gtag/js?id=UA-71038512-1"></script>
    
    <script async="" src="https://www.googletagmanager.com/gtm.js?id=GTM-W4WB2DP"></script>
    <script async="" src="https://connect.facebook.net/en_US/fbevents.js"></script>
    <script async="" src="//static.ads-twitter.com/uwt.js"></script>
    
    <!-- Twitter universal website tag code -->
        <script>
            !function (e, t, n, s, u, a) {
                e.twq || (s = e.twq = function () {
                    s.exe ? s.exe.apply(s, arguments) : s.queue.push(arguments);
                }, s.version = '1.1', s.queue = [], u = t.createElement(n), u.async = !0, u.src = '//static.ads-twitter.com/uwt.js',
                        a = t.getElementsByTagName(n)[0], a.parentNode.insertBefore(u, a))
            }(window, document, 'script');
            // Insert Twitter Pixel ID and Standard Event data below
            twq('init', 'o17zv');
            twq('track', 'PageView');
        </script>
    <!-- End Twitter universal website tag code -->
</head>

<body class="font-sans antialiased bg-[#f1f5f8]">
    @inertia
</body>

</html>