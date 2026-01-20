<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="csrf-token" content="{{ csrf_token() }}" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" />
    <meta name="verify-reviews" content="$2y$10$svE4L1z49ENEDY1HjtS6Ye7fYMJNBkCX7AYDiX.pOXP8aQt0UTWKm" />
    <meta name="google-site-verification" content="uUIzG62N4Rv7C_-fIqnFGpGPpp0bF2_ViqdF--eHCyE" />
    <meta name="public" content="Public" />
    <meta name="author" content="Abdul Rehman" />
    <meta name="Robots" content="all" />
    <meta head-key="language" content="English" />
    <?php if(isset($headerArr) || !empty($headerArr)): ?>
    <title> <?php echo $headerArr['metaTitle']; ?> </title>
    <meta head-key="description" type="description" content="<?php echo $headerArr['description']; ?>" />
    <?php endif; ?>
    <link rel="canonical" href="<?php echo (!empty($headerArr['og:url']) ? $headerArr['og:url'] : 'https://www.rehmantravel.com'); ?>" />
<meta head-key="fb:admins" property="fb:admins" content="100064855023859"/>
    <meta head-key="og:locale" property="og:locale" content="en-us" />
    <meta head-key="og:type" property="og:type" content="website" />
    <meta head-key="og:site_name" property="og:site_name" content="Rehman Travels" />
    <?php if(isset($headerArr) || !empty($headerArr)): ?>
<meta head-key="og:title" property="og:title" content="<?php echo $headerArr['metaTitle']; ?>" />
    <meta head-key="og:description" property="og:description" content="<?php echo $headerArr['description']; ?>" />
    <meta head-key="og:url" property="og:url" content="<?php echo (!empty($headerArr['og:url']) ? $headerArr['og:url'] : 'https://www.rehmantravel.com'); ?>" />
    <meta head-key="og:image" property="og:image" content="https://www.rehmantravel.com/<?php echo $headerArr['image']; ?>" />
    <meta head-key="og:image:secure_url" property="og:image:secure_url" content="https://www.rehmantravel.com/<?php echo $headerArr['og:image:secure_url']; ?>" />
    <meta head-key="og:image:type" property="og:image:type" content="image/png" />
    <meta head-key="og:image:width" property="og:image:width" content="400" />
    <meta head-key="og:image:height" property="og:image:height" content="300" />
    <meta head-key="og:image:alt" property="og:image:alt" content="<?php echo  $headerArr['metaTitle']; ?>" />
    <?php endif; ?>
    
    <?php if(!empty($headerArr) && isset($headerArr['schemaVal']) && !empty($headerArr['schemaVal'])): ?>
        <script type="application/ld+json">
        {
            {!! strip_tags($headerArr['schemaVal']) !!}
        }
        </script>
    <?php else: ?>
<script type="application/ld+json">
        {"@context":"http://schema.org",
        "@type":"Product",
        "name":"RehmanTravels",
        "description":"Rehman travels top rank travel agency in Islamabad.",
        "brand":"RehmanTravels",
        "url":"https://www.rehmantravel.com",
        "aggregateRating":{"@type":"AggregateRating","ratingValue":"4.7","reviewCount":"2852"}}
    </script>
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
    <!-- Google Tag Manager -->
     <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
     new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
     j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
     'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
     })(window,document,'script','dataLayer','GTM-W4WB2DP');</script>
     <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-W4WB2DP" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!--<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-5000022282195426" crossorigin="anonymous"></script>-->
    <!--<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-2095458935253019" crossorigin="anonymous"></script>-->
    
    <!-- Google tag (gtag.js) aded on 19082024 -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-FTRJBK3V0T"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
    
      gtag('config', 'G-FTRJBK3V0T');
    </script>
    
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async="" src="https://www.googletagmanager.com/gtag/js?id=UA-71038512-1"></script>
    <script async="" src="https://www.googletagmanager.com/gtm.js?id=GTM-W4WB2DP"></script>
    
    <!-- Meta Pixel Code -->
    <script>
    !function(f,b,e,v,n,t,s)
    {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};
    if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
    n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];
    s.parentNode.insertBefore(t,s)}(window, document,'script',
    'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '875045070736510');
    fbq('track', 'PageView');
    </script>
    <noscript><img height="1" width="1" style="display:none"
    src="https://www.facebook.com/tr?id=875045070736510&ev=PageView&noscript=1"
    /></noscript>
    <!-- End Meta Pixel Code -->
    
    <!-- Meta Pixel Umrah Code -->
    <script>
    !function(f,b,e,v,n,t,s)
    {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
    n.callMethod.apply(n,arguments):n.queue.push(arguments)};
    if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
    n.queue=[];t=b.createElement(e);t.async=!0;
    t.src=v;s=b.getElementsByTagName(e)[0];
    s.parentNode.insertBefore(t,s)}(window, document,'script',
    'https://connect.facebook.net/en_US/fbevents.js');
    fbq('init', '469294422768534');
    fbq('track', 'PageView');
    </script>
    <noscript><img height="1" width="1" style="display:none"
    src="https://www.facebook.com/tr?id=469294422768534&ev=PageView&noscript=1"
    /></noscript>
    <!-- End Meta Pixel Code -->

    <!-- Facebook Pixel Code -->
    <script> !function(f,b,e,v,n,t,s) {if(f.fbq)return;n=f.fbq=function(){n.callMethod? n.callMethod.apply(n,arguments):n.queue.push(arguments)}; if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0'; n.queue=[];t=b.createElement(e);t.async=!0; t.src=v;s=b.getElementsByTagName(e)[0]; s.parentNode.insertBefore(t,s)}(window, document,'script', 'https://connect.facebook.net/en_US/fbevents.js'); fbq('init', '100723900653355'); fbq('track', 'PageView'); </script> <noscript><img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=100723900653355&ev=PageView&noscript=1" /></noscript>
    <script async="" src="https://connect.facebook.net/en_US/fbevents.js"></script>
    
</head>


<body class="font-sans antialiased bg-[#f1f5f8]">
    @inertia
</body>

</html>