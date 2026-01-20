<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <title>{{$title}}</title>
        <style>
            *,:before,:after {
                box-sizing: border-box;
                border-width: 0;
                border-style: solid;
                border-color: #e5e7eb;
            }
            
            :before,:after {
                --tw-content: ""
            }
            
            html,:host {
                line-height: 1.5;
                -webkit-text-size-adjust: 100%;
                -moz-tab-size: 4;
                -o-tab-size: 4;
                tab-size: 4;
                font-family: Jost,ui-sans-serif,system-ui,sans-serif,"Apple Color Emoji","Segoe UI Emoji",Segoe UI Symbol,"Noto Color Emoji";
                font-feature-settings: normal;
                font-variation-settings: normal;
                -webkit-tap-highlight-color: transparent;
            }
            
            body {
                margin: 0;
                line-height: inherit;
            }
            
            hr {
                height: 0;
                color: inherit;
                border-top-width: 1px;
            }
            
            abbr:where([title]) {
                -webkit-text-decoration: underline dotted;
                text-decoration: underline dotted;
            }
            
            h1,h2,h3,h4,h5,h6 {
                font-size: inherit;
                font-weight: inherit;
            }
            
            a {
                color: inherit;
                text-decoration: inherit;
            }
            
            b,strong {
                font-weight: bolder;
            }
            
            code,kbd,samp,pre {
                font-family: ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,Liberation Mono,Courier New,monospace;
                font-feature-settings: normal;
                font-variation-settings: normal;
                font-size: 1em;
            }
            
            small {
                font-size: 80%;
            }
            
            sub,sup {
                font-size: 75%;
                line-height: 0;
                position: relative;
                vertical-align: baseline;
            }
            
            sub {
                bottom: -.25em;
            }
            
            sup {
                top: -.5em;
            }
            
            table {
                text-indent: 0;
                border-color: inherit;
                border-collapse: collapse;
            }
            
            .border {
                border-width: 1px;
            }
            
            button,input,optgroup,select,textarea {
                font-family: inherit;
                font-feature-settings: inherit;
                font-variation-settings: inherit;
                font-size: 100%;
                font-weight: inherit;
                line-height: inherit;
                letter-spacing: inherit;
                color: inherit;
                margin: 0;
                padding: 0;
            }
            
            button,select {
                text-transform: none;
            }
            
            button,input:where([type=button]),input:where([type=reset]),input:where([type=submit]) {
                -webkit-appearance: button;
                background-color: transparent;
                background-image: none;
            }
            
            :-moz-focusring {
                outline: auto;
            }
            
            :-moz-ui-invalid {
                box-shadow: none;
            }
            
            progress {
                vertical-align: baseline;
            }
            
            ::-webkit-inner-spin-button,::-webkit-outer-spin-button {
                height: auto;
            }
            
            [type=search] {
                -webkit-appearance: textfield;
                outline-offset: -2px;
            }
            
            ::-webkit-search-decoration {
                -webkit-appearance: none;
            }
            
            ::-webkit-file-upload-button {
                -webkit-appearance: button;
                font: inherit;
            }
            
            summary {
                display: list-item;
            }
            
            blockquote,dl,dd,h1,h2,h3,h4,h5,h6,hr,figure,p,pre {
                margin: 0;
            }
            
            fieldset {
                margin: 0;
                padding: 0;
            }
            
            legend {
                padding: 0;
            }
            
            ol,ul,menu {
                list-style: none;
                margin: 0;
                padding: 0;
            }
            
            dialog {
                padding: 0;
            }
            
            textarea {
                resize: vertical;
            }
            
            input::-moz-placeholder,textarea::-moz-placeholder {
                opacity: 1;
                color: #9ca3af;
            }
            
            input::placeholder,textarea::placeholder {
                opacity: 1;
                color: #9ca3af;
            }
            
            button,[role=button] {
                cursor: pointer;
            }
            
            :disabled {
                cursor: default;
            }
            
            img,svg,video,canvas,audio,iframe,embed,object {
                display: block;
                vertical-align: middle;
            }
            
            img,video {
                max-width: 100%;
                height: auto;
            }
            
            [hidden] {
                display: none;
            }
            .w-1\/2 {
                width: 50%;
            }
            .sr-only {
                position: absolute;
                width: 1px;
                height: 1px;
                padding: 0;
                margin: -1px;
                overflow: hidden;
                clip: rect(0,0,0,0);
                white-space: nowrap;
                border-width: 0;
            }
            
            .pointer-events-none {
                pointer-events: none;
            }
            
            .collapse {
                visibility: collapse;
            }
            
            .static {
                position: static;
            }
            
            .fixed {
                position: fixed;
            }
            
            .absolute {
                position: absolute;
            }
            
            .relative {
                position: relative;
            }
            
            .sticky {
                position: sticky;
            }
            
            .inset-0 {
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
            }
            
            .inset-y-0 {
                top: 0;
                bottom: 0;
            }
            
            .-bottom-10 {
                bottom: -2.5rem;
            }
            
            .-bottom-3 {
                bottom: -.75rem;
            }
            
            .-left-2 {
                left: -.5rem;
            }
            
            .-left-3 {
                left: -.75rem;
            }
            
            .-left-\[0\.6rem\] {
                left: -.6rem;
            }
            
            .-right-10 {
                right: -2.5rem;
            }
            
            .-right-3 {
                right: -.75rem;
            }
            
            .-right-\[12px\] {
                right: -12px;
            }
            
            .-top-1 {
                top: -.25rem;
            }
            
            .-top-1\.5 {
                top: -.375rem;
            }
            
            .-top-2 {
                top: -.5rem;
            }
            
            .-top-3 {
                top: -.75rem;
            }
            
            .-top-\[0\.5rem\] {
                top: -.5rem;
            }
            
            .-top-\[1\.4rem\] {
                top: -1.4rem;
            }
            
            .-top-\[20\.5rem\] {
                top: -20.5rem;
            }
            
            .-top-\[33px\] {
                top: -33px;
            }
            
            .-top-\[9px\] {
                top: -9px;
            }
            
            .bottom-0 {
                bottom: 0;
            }
            
            .bottom-12 {
                bottom: 3rem;
            }
            
            .bottom-2 {
                bottom: .5rem;
            }
            
            .bottom-\[10\.3rem\] {
                bottom: 10.3rem;
            }
            
            .bottom-\[6\.5rem\] {
                bottom: 6.5rem;
            }
            
            .left-0 {
                left: 0;
            }
            
            .left-1\/2 {
                left: 50%;
            }
            
            .left-2 {
                left: .5rem;
            }
            
            .left-2\.5 {
                left: .625rem;
            }
            
            .left-3 {
                left: .75rem;
            }
            
            .left-\[11\.6rem\] {
                left: 11.6rem;
            }
            
            .left-\[2\.3rem\] {
                left: 2.3rem;
            }
            
            .left-\[5\.8rem\] {
                left: 5.8rem;
            }
            
            .right-0 {
                right: 0;
            }
            
            .right-1 {
                right: .25rem;
            }
            
            .right-2 {
                right: .5rem;
            }
            
            .right-3 {
                right: .75rem;
            }
            
            .right-6 {
                right: 1.5rem;
            }
            
            .right-7 {
                right: 1.75rem;
            }
            
            .right-\[8px\] {
                right: 8px;
            }
            
            .start-1 {
                inset-inline-start: .25rem;
            }
            
            .top-0 {
                top: 0;
            }
            
            .top-1 {
                top: .25rem;
            }
            
            .top-1\/2 {
                top: 50%;
            }
            
            .top-10 {
                top: 2.5rem;
            }
            
            .top-16 {
                top: 4rem;
            }
            
            .top-2 {
                top: .5rem;
            }
            
            .top-20 {
                top: 5rem;
            }
            
            .top-3 {
                top: .75rem;
            }
            
            .top-4 {
                top: 1rem;
            }
            
            .top-6 {
                top: 1.5rem;
            }
            
            .top-7 {
                top: 1.75rem;
            }
            
            .top-\[2\.6rem\] {
                top: 2.6rem;
            }
            
            .top-\[3\.2rem\] {
                top: 3.2rem;
            }
            
            .top-\[4\.5rem\] {
                top: 4.5rem;
            }
            
            .top-\[7px\] {
                top: 7px;
            }
            
            .top-\[8rem\] {
                top: 8rem;
            }
            
            .isolate {
                isolation: isolate;
            }
            
            .z-0 {
                z-index: 0;
            }
            
            .z-10 {
                z-index: 10;
            }
            
            .z-20 {
                z-index: 20;
            }
            
            .z-30 {
                z-index: 30;
            }
            
            .z-40 {
                z-index: 40;
            }
            
            .z-50 {
                z-index: 50;
            }
            
            .z-\[11\] {
                z-index: 11;
            }
            
            .z-\[9999\] {
                z-index: 9999;
            }
            
            .z-\[999\] {
                z-index: 999;
            }
            
            .order-first {
                order: -9999;
            }
            
            .col-span-1 {
                grid-column: span 1 / span 1;
            }
            
            .col-span-10 {
                grid-column: span 10 / span 10;
            }
            
            .col-span-12 {
                grid-column: span 12 / span 12;
            }
            
            .col-span-2 {
                grid-column: span 2 / span 2;
            }
            
            .col-span-3 {
                grid-column: span 3 / span 3;
            }
            
            .col-span-4 {
                grid-column: span 4 / span 4;
            }
            
            .col-span-5 {
                grid-column: span 5 / span 5;
            }
            
            .col-span-6 {
                grid-column: span 6 / span 6;
            }
            
            .col-span-7 {
                grid-column: span 7 / span 7;
            }
            
            .col-span-8 {
                grid-column: span 8 / span 8;
            }
            
            .col-span-9 {
                grid-column: span 9 / span 9;
            }
            
            .float-right {
                float: right;
            }
            
            .float-left {
                float: left;
            }
            
            .float-none {
                float: none;
            }
            
            .m-0 {
                margin: 0;
            }
            
            .m-2 {
                margin: .5rem;
            }
            
            .m-3 {
                margin: .75rem;
            }
            
            .m-\[0_-8px\] {
                margin: 0 -8px;
            }
            
            .m-\[1rem_0rem\] {
                margin: 1rem 0rem;
            }
            
            .m-auto {
                margin: auto;
            }
            
            .-mx-1 {
                margin-left: -.25rem;
                margin-right: -.25rem;
            }
            
            .-mx-3 {
                margin-left: -.75rem;
                margin-right: -.75rem;
            }
            
            .mx-0 {
                margin-left: 0;
                margin-right: 0;
            }
            
            .mx-1 {
                margin-left: .25rem;
                margin-right: .25rem;
            }
            
            .mx-2 {
                margin-left: .5rem;
                margin-right: .5rem;
            }
            
            .mx-3 {
                margin-left: .75rem;
                margin-right: .75rem;
            }
            
            .mx-4 {
                margin-left: 1rem;
                margin-right: 1rem;
            }
            
            .mx-5 {
                margin-left: 1.25rem;
                margin-right: 1.25rem;
            }
            
            .mx-auto {
                margin-left: auto;
                margin-right: auto;
            }
            
            .my-1 {
                margin-top: .25rem;
                margin-bottom: .25rem;
            }
            
            .my-10 {
                margin-top: 2.5rem;
                margin-bottom: 2.5rem;
            }
            
            .my-12 {
                margin-top: 3rem;
                margin-bottom: 3rem;
            }
            
            .my-2 {
                margin-top: .5rem;
                margin-bottom: .5rem;
            }
            
            .my-3 {
                margin-top: .75rem;
                margin-bottom: .75rem;
            }
            
            .my-4 {
                margin-top: 1rem;
                margin-bottom: 1rem;
            }
            
            .my-6 {
                margin-top: 1.5rem;
                margin-bottom: 1.5rem;
            }
            
            .my-auto {
                margin-top: auto;
                margin-bottom: auto;
            }
            
            .-ml-\[8px\] {
                margin-left: -8px;
            }
            
            .-ml-px {
                margin-left: -1px;
            }
            
            .-mr-0 {
                margin-right: -0px;
            }
            
            .-mr-0\.5 {
                margin-right: -.125rem;
            }
            
            .-mr-2 {
                margin-right: -.5rem;
            }
            
            .-mt-16 {
                margin-top: -4rem;
            }
            
            .-mt-48 {
                margin-top: -12rem;
            }
            
            .-mt-52 {
                margin-top: -13rem;
            }
            
            .-mt-56 {
                margin-top: -14rem;
            }
            
            .-mt-px {
                margin-top: -1px;
            }
            
            .mb-0 {
                margin-bottom: 0;
            }
            
            .mb-1 {
                margin-bottom: .25rem;
            }
            
            .mb-10 {
                margin-bottom: 2.5rem;
            }
            
            .mb-2 {
                margin-bottom: .5rem;
            }
            
            .mb-3 {
                margin-bottom: .75rem;
            }
            
            .mb-4 {
                margin-bottom: 1rem;
            }
            
            .mb-40 {
                margin-bottom: 10rem;
            }
            
            .mb-5 {
                margin-bottom: 1.25rem;
            }
            
            .mb-6 {
                margin-bottom: 1.5rem;
            }
            
            .mb-8 {
                margin-bottom: 2rem;
            }
            
            .mb-9 {
                margin-bottom: 2.25rem
            }
            
            .mb-\[2\.2rem\] {
                margin-bottom: 2.2rem
            }
            
            .me-2 {
                margin-inline-end:.5rem}
            
            .me-3 {
                margin-inline-end:.75rem}
            
            .ml-0 {
                margin-left: 0
            }
            
            .ml-1 {
                margin-left: .25rem
            }
            
            .ml-12 {
                margin-left: 3rem
            }
            
            .ml-2 {
                margin-left: .5rem
            }
            
            .ml-2\.5 {
                margin-left: .625rem
            }
            
            .ml-3 {
                margin-left: .75rem
            }
            
            .ml-4 {
                margin-left: 1rem
            }
            
            .ml-6 {
                margin-left: 1.5rem
            }
            
            .ml-\[1rem\] {
                margin-left: 1rem
            }
            
            .mr-0 {
                margin-right: 0
            }
            
            .mr-1 {
                margin-right: .25rem
            }
            
            .mr-2 {
                margin-right: .5rem
            }
            
            .mr-3 {
                margin-right: .75rem
            }
            
            .mr-4,.mr-\[1rem\] {
                margin-right: 1rem
            }
            
            .ms-2 {
                margin-inline-start:.5rem}
            
            .ms-5 {
                margin-inline-start:1.25rem}
            
            .ms-auto {
                margin-inline-start:auto}
            
            .mt-0 {
                margin-top: 0
            }
            
            .mt-1 {
                margin-top: .25rem
            }
            
            .mt-10 {
                margin-top: 2.5rem
            }
            
            .mt-14 {
                margin-top: 3.5rem
            }
            
            .mt-2 {
                margin-top: .5rem
            }
            
            .mt-3 {
                margin-top: .75rem
            }
            
            .mt-4 {
                margin-top: 1rem
            }
            
            .mt-44 {
                margin-top: 11rem
            }
            
            .mt-5 {
                margin-top: 1.25rem
            }
            
            .mt-6 {
                margin-top: 1.5rem
            }
            
            .mt-8 {
                margin-top: 2rem
            }
            
            .mt-9 {
                margin-top: 2.25rem
            }
            
            .mt-\[0\.4rem\] {
                margin-top: .4rem
            }
            
            .mt-\[18px\] {
                margin-top: 18px
            }
            
            .mt-\[1rem\] {
                margin-top: 1rem
            }
            
            .mt-\[3px\] {
                margin-top: 3px
            }
            
            .mt-\[8px\] {
                margin-top: 8px
            }
            
            .line-clamp-1 {
                overflow: hidden;
                display: -webkit-box;
                -webkit-box-orient: vertical;
                -webkit-line-clamp: 1
            }
            
            .line-clamp-3 {
                overflow: hidden;
                display: -webkit-box;
                -webkit-box-orient: vertical;
                -webkit-line-clamp: 3
            }
            
            .block {
                display: block
            }
            
            .inline-block {
                display: inline-block
            }
            
            .inline {
                display: inline
            }
            
            .flex {
                display: flex
            }
            
            .inline-flex {
                display: inline-flex
            }
            
            .table {
                display: table
            }
            
            .grid {
                display: grid
            }
            
            .contents {
                display: contents
            }
            
            .list-item {
                display: list-item
            }
            
            .hidden {
                display: none
            }
            
            .size-7 {
                width: 1.75rem;
                height: 1.75rem
            }
            
            .h-10 {
                height: 2.5rem
            }
            
            .h-11 {
                height: 2.75rem
            }
            
            .h-12 {
                height: 3rem
            }
            
            .h-14 {
                height: 3.5rem
            }
            
            .h-16 {
                height: 4rem
            }
            
            .h-2 {
                height: .5rem
            }
            
            .h-2\.5 {
                height: .625rem
            }
            
            .h-24 {
                height: 6rem
            }
            
            .h-28 {
                height: 7rem
            }
            
            .h-3 {
                height: .75rem
            }
            
            .h-4 {
                height: 1rem
            }
            
            .h-5 {
                height: 1.25rem
            }
            
            .h-6 {
                height: 1.5rem
            }
            
            .h-7 {
                height: 1.75rem
            }
            
            .h-8 {
                height: 2rem
            }
            
            .h-9 {
                height: 2.25rem
            }
            
            .h-\[0\.3rem\] {
                height: .3rem
            }
            
            .h-\[1000px\] {
                height: 1000px
            }
            
            .h-\[112\] {
                height: 112
            }
            
            .h-\[170px\] {
                height: 170px
            }
            
            .h-\[180px\] {
                height: 180px
            }
            
            .h-\[193px\] {
                height: 193px
            }
            
            .h-\[2\.48rem\] {
                height: 2.48rem
            }
            
            .h-\[2\.68rem\] {
                height: 2.68rem
            }
            
            .h-\[250px\] {
                height: 250px
            }
            
            .h-\[25px\] {
                height: 25px
            }
            
            .h-\[27\.5rem\] {
                height: 27.5rem
            }
            
            .h-\[3\.42rem\] {
                height: 3.42rem
            }
            
            .h-\[3\.5rem\] {
                height: 3.5rem
            }
            
            .h-\[3\.6rem\] {
                height: 3.6rem
            }
            
            .h-\[320px\] {
                height: 320px
            }
            
            .h-\[32rem\] {
                height: 32rem
            }
            
            .h-\[68vh\] {
                height: 68vh
            }
            
            .h-full {
                height: 100%
            }
            
            .h-screen {
                height: 100vh
            }
            
            .max-h-52 {
                max-height: 13rem
            }
            
            .max-h-\[15rem\] {
                max-height: 15rem
            }
            
            .max-h-\[24\.5rem\] {
                max-height: 24.5rem
            }
            
            .max-h-\[30px\] {
                max-height: 30px
            }
            
            .min-h-\[0\.3rem\] {
                min-height: .3rem
            }
            
            .min-h-\[37px\] {
                min-height: 37px
            }
            
            .min-h-\[46px\] {
                min-height: 46px
            }
            
            .min-h-full {
                min-height: 100%
            }
            
            .min-h-screen {
                min-height: 100vh
            }
            
            .w-1\/2 {
                width: 50%
            }
            
            .w-1\/5 {
                width: 20%
            }
            
            .w-10 {
                width: 2.5rem
            }
            
            .w-11\/12 {
                width: 91.666667%
            }
            
            .w-12 {
                width: 3rem
            }
            
            .w-2 {
                width: .5rem
            }
            
            .w-2\.5 {
                width: .625rem
            }
            
            .w-20 {
                width: 5rem
            }
            
            .w-24 {
                width: 6rem
            }
            
            .w-28 {
                width: 7rem
            }
            
            .w-3 {
                width: .75rem
            }
            
            .w-3\/4 {
                width: 75%
            }
            
            .w-32 {
                width: 8rem
            }
            
            .w-36 {
                width: 9rem
            }
            
            .w-4 {
                width: 1rem
            }
            
            .w-40 {
                width: 10rem
            }
            
            .w-44 {
                width: 11rem
            }
            
            .w-48 {
                width: 12rem
            }
            
            .w-5 {
                width: 1.25rem
            }
            
            .w-52 {
                width: 13rem
            }
            
            .w-56 {
                width: 14rem
            }
            
            .w-6 {
                width: 1.5rem
            }
            
            .w-60 {
                width: 15rem
            }
            
            .w-7 {
                width: 1.75rem
            }
            
            .w-72 {
                width: 18rem
            }
            
            .w-8 {
                width: 2rem
            }
            
            .w-80 {
                width: 20rem
            }
            
            .w-\[100\%\] {
                width: 100%
            }
            
            .w-\[100px\] {
                width: 100px
            }
            
            .w-\[13\%\] {
                width: 13%
            }
            
            .w-\[15\%\] {
                width: 15%
            }
            
            .w-\[190px\] {
                width: 190px
            }
            
            .w-\[20\%\] {
                width: 20%
            }
            
            .w-\[25px\] {
                width: 25px
            }
            
            .w-\[25rem\] {
                width: 25rem
            }
            
            .w-\[263px\] {
                width: 263px
            }
            
            .w-\[30\.4\%\] {
                width: 30.4%
            }
            
            .w-\[320px\] {
                width: 320px
            }
            
            .w-\[33\%\] {
                width: 33%
            }
            
            .w-\[4\.8rem\] {
                width: 4.8rem
            }
            
            .w-\[45\%\] {
                width: 45%
            }
            
            .w-\[48\.4\%\] {
                width: 48.4%
            }
            
            .w-\[49\%\] {
                width: 49%
            }
            
            .w-\[5\.5rem\] {
                width: 5.5rem
            }
            
            .w-\[50\%\] {
                width: 50%
            }
            
            .w-\[6\.9rem\] {
                width: 6.9rem
            }
            
            .w-\[60\%\] {
                width: 60%
            }
            
            .w-\[66\.4\%\] {
                width: 66.4%
            }
            
            .w-\[6rem\] {
                width: 6rem
            }
            
            .w-\[80\%\] {
                width: 80%
            }
            
            .w-\[80px\] {
                width: 80px
            }
            
            .w-\[82\%\] {
                width: 82%
            }
            
            .w-\[83\%\] {
                width: 83%
            }
            
            .w-\[85\%\] {
                width: 85%
            }
            
            .w-\[90\%\] {
                width: 90%
            }
            
            .w-\[90\.4\%\] {
                width: 90.4%
            }
            
            .w-\[95\%\] {
                width: 95%
            }
            
            .w-\[98\%\] {
                width: 98%
            }
            
            .w-auto {
                width: auto
            }
            
            .w-fit {
                width: -moz-fit-content;
                width: fit-content
            }
            
            .w-full {
                width: 100%
            }
            
            .w-screen {
                width: 100vw
            }
            
            .min-w-\[200px\] {
                min-width: 200px
            }
            
            .min-w-\[400px\] {
                min-width: 400px
            }
            
            .max-w-52 {
                max-width: 13rem
            }
            
            .max-w-6xl {
                max-width: 72rem
            }
            
            .max-w-7xl {
                max-width: 80rem
            }
            
            .max-w-\[30px\] {
                max-width: 30px
            }
            
            .max-w-lg {
                max-width: 32rem
            }
            
            .max-w-screen-xl {
                max-width: 1280px
            }
            
            .max-w-xl {
                max-width: 36rem
            }
            
            .flex-1 {
                flex: 1 1 0%
            }
            
            .flex-shrink-0 {
                flex-shrink: 0
            }
            
            .grow {
                flex-grow: 1
            }
            
            .table-auto {
                table-layout: auto
            }
            
            .table-fixed {
                table-layout: fixed
            }
            
            .border-collapse {
                border-collapse: collapse
            }
            
            .origin-\[0\] {
                transform-origin: 0
            }
            
            .origin-top {
                transform-origin: top
            }
            
            .origin-top-left {
                transform-origin: top left
            }
            
            .origin-top-right {
                transform-origin: top right
            }
            
            .-translate-x-1 {
                --tw-translate-x: -.25rem;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .-translate-x-1\/2 {
                --tw-translate-x: -50%;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .-translate-x-12 {
                --tw-translate-x: -3rem;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .-translate-y-1\/2 {
                --tw-translate-y: -50%;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .-translate-y-4 {
                --tw-translate-y: -1rem;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .-translate-y-6 {
                --tw-translate-y: -1.5rem;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .translate-y-0 {
                --tw-translate-y: 0px;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .translate-y-4 {
                --tw-translate-y: 1rem;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .rotate-90 {
                --tw-rotate: 90deg;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .scale-100 {
                --tw-scale-x: 1;
                --tw-scale-y: 1;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .scale-75 {
                --tw-scale-x: .75;
                --tw-scale-y: .75;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .scale-95 {
                --tw-scale-x: .95;
                --tw-scale-y: .95;
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            .transform {
                transform: translate(var(--tw-translate-x),var(--tw-translate-y)) rotate(var(--tw-rotate)) skew(var(--tw-skew-x)) skewY(var(--tw-skew-y)) scaleX(var(--tw-scale-x)) scaleY(var(--tw-scale-y))
            }
            
            @keyframes pulse {
                50% {
                    opacity: .5
                }
            }
            
            .animate-pulse {
                animation: pulse 2s cubic-bezier(.4,0,.6,1) infinite
            }
            
            .cursor-default {
                cursor: default
            }
            
            .cursor-not-allowed {
                cursor: not-allowed
            }
            
            .cursor-pointer {
                cursor: pointer
            }
            
            .cursor-text {
                cursor: text
            }
            
            .cursor-wait {
                cursor: wait
            }
            
            .select-none {
                -webkit-user-select: none;
                -moz-user-select: none;
                user-select: none
            }
            
            .resize {
                resize: both
            }
            
            .list-decimal {
                list-style-type: decimal
            }
            
            .list-disc {
                list-style-type: disc
            }
            
            .appearance-none {
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none
            }
            
            .grid-cols-1 {
                grid-template-columns: repeat(1,minmax(0,1fr))
            }
            
            .grid-cols-11 {
                grid-template-columns: repeat(11,minmax(0,1fr))
            }
            
            .grid-cols-12 {
                grid-template-columns: repeat(12,minmax(0,1fr))
            }
            
            .grid-cols-2 {
                grid-template-columns: repeat(2,minmax(0,1fr))
            }
            
            .grid-cols-3 {
                grid-template-columns: repeat(3,minmax(0,1fr))
            }
            
            .flex-col {
                flex-direction: column
            }
            
            .flex-wrap {
                flex-wrap: wrap
            }
            
            .items-end {
                align-items: flex-end
            }
            
            .items-center {
                align-items: center
            }
            
            .justify-start {
                justify-content: flex-start
            }
            
            .justify-end {
                justify-content: flex-end
            }
            
            .justify-center {
                justify-content: center
            }
            
            .justify-between {
                justify-content: space-between
            }
            
            .justify-items-center {
                justify-items: center
            }
            
            .gap-1 {
                gap: .25rem
            }
            
            .gap-2 {
                gap: .5rem
            }
            
            .gap-3 {
                gap: .75rem
            }
            
            .gap-4 {
                gap: 1rem
            }
            
            .gap-5 {
                gap: 1.25rem
            }
            
            .gap-8 {
                gap: 2rem
            }
            
            .gap-x-1 {
                -moz-column-gap: .25rem;
                column-gap: .25rem
            }
            
            .gap-x-2 {
                -moz-column-gap: .5rem;
                column-gap: .5rem
            }
            
            .gap-x-3 {
                -moz-column-gap: .75rem;
                column-gap: .75rem
            }
            
            .gap-y-1 {
                row-gap: .25rem
            }
            
            .gap-y-3 {
                row-gap: .75rem
            }
            
            .gap-y-4 {
                row-gap: 1rem
            }
            
            .gap-y-5 {
                row-gap: 1.25rem
            }
            
            .gap-y-6 {
                row-gap: 1.5rem
            }
            
            .-space-x-px>:not([hidden])~:not([hidden]) {
                --tw-space-x-reverse: 0;
                margin-right: calc(-1px * var(--tw-space-x-reverse));
                margin-left: calc(-1px * calc(1 - var(--tw-space-x-reverse)))
            }
            
            .space-x-1>:not([hidden])~:not([hidden]) {
                --tw-space-x-reverse: 0;
                margin-right: calc(.25rem * var(--tw-space-x-reverse));
                margin-left: calc(.25rem * calc(1 - var(--tw-space-x-reverse)))
            }
            
            .space-x-4>:not([hidden])~:not([hidden]) {
                --tw-space-x-reverse: 0;
                margin-right: calc(1rem * var(--tw-space-x-reverse));
                margin-left: calc(1rem * calc(1 - var(--tw-space-x-reverse)))
            }
            
            .space-x-8>:not([hidden])~:not([hidden]) {
                --tw-space-x-reverse: 0;
                margin-right: calc(2rem * var(--tw-space-x-reverse));
                margin-left: calc(2rem * calc(1 - var(--tw-space-x-reverse)))
            }
            
            .space-y-1>:not([hidden])~:not([hidden]) {
                --tw-space-y-reverse: 0;
                margin-top: calc(.25rem * calc(1 - var(--tw-space-y-reverse)));
                margin-bottom: calc(.25rem * var(--tw-space-y-reverse))
            }
            
            .space-y-2>:not([hidden])~:not([hidden]) {
                --tw-space-y-reverse: 0;
                margin-top: calc(.5rem * calc(1 - var(--tw-space-y-reverse)));
                margin-bottom: calc(.5rem * var(--tw-space-y-reverse))
            }
            
            .space-y-3>:not([hidden])~:not([hidden]) {
                --tw-space-y-reverse: 0;
                margin-top: calc(.75rem * calc(1 - var(--tw-space-y-reverse)));
                margin-bottom: calc(.75rem * var(--tw-space-y-reverse))
            }
            
            .space-y-4>:not([hidden])~:not([hidden]) {
                --tw-space-y-reverse: 0;
                margin-top: calc(1rem * calc(1 - var(--tw-space-y-reverse)));
                margin-bottom: calc(1rem * var(--tw-space-y-reverse))
            }
            
            .space-y-6>:not([hidden])~:not([hidden]) {
                --tw-space-y-reverse: 0;
                margin-top: calc(1.5rem * calc(1 - var(--tw-space-y-reverse)));
                margin-bottom: calc(1.5rem * var(--tw-space-y-reverse))
            }
            
            .overflow-auto {
                overflow: auto
            }
            
            .overflow-hidden {
                overflow: hidden
            }
            
            .\!overflow-visible {
                overflow: visible!important
            }
            
            .overflow-x-auto {
                overflow-x: auto
            }
            
            .overflow-y-auto {
                overflow-y: auto
            }
            
            .overflow-y-scroll {
                overflow-y: scroll
            }
            
            .truncate {
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap
            }
            
            .text-ellipsis {
                text-overflow: ellipsis
            }
            
            .whitespace-nowrap {
                white-space: nowrap
            }
            
            .break-words {
                overflow-wrap: break-word
            }
            
            .break-all {
                word-break: break-all
            }
            
            .rounded {
                border-radius: .25rem
            }
            
            .rounded-2xl {
                border-radius: 1rem
            }
            
            .rounded-\[0\.25rem\] {
                border-radius: .25rem
            }
            
            .rounded-\[10px\] {
                border-radius: 10px
            }
            
            .rounded-\[50\%\] {
                border-radius: 50%
            }
            
            .rounded-\[8px\] {
                border-radius: 8px
            }
            
            .rounded-full {
                border-radius: 9999px
            }
            
            .rounded-lg {
                border-radius: .5rem
            }
            
            .rounded-md {
                border-radius: .375rem
            }
            
            .rounded-none {
                border-radius: 0
            }
            
            .rounded-sm {
                border-radius: .125rem
            }
            
            .rounded-xl {
                border-radius: .75rem
            }
            
            .rounded-b-md {
                border-bottom-right-radius: .375rem;
                border-bottom-left-radius: .375rem
            }
            
            .rounded-l-md {
                border-top-left-radius: .375rem;
                border-bottom-left-radius: .375rem
            }
            
            .rounded-r-md {
                border-top-right-radius: .375rem;
                border-bottom-right-radius: .375rem
            }
            
            .rounded-t {
                border-top-left-radius: .25rem;
                border-top-right-radius: .25rem
            }
            
            .rounded-t-2xl {
                border-top-left-radius: 1rem;
                border-top-right-radius: 1rem
            }
            
            .rounded-t-lg {
                border-top-left-radius: .5rem;
                border-top-right-radius: .5rem
            }
            
            .rounded-t-md {
                border-top-left-radius: .375rem;
                border-top-right-radius: .375rem
            }
            
            .rounded-bl-\[34px\] {
                border-bottom-left-radius: 34px
            }
            
            .rounded-bl-md {
                border-bottom-left-radius: .375rem
            }
            
            .rounded-bl-xl {
                border-bottom-left-radius: .75rem
            }
            
            .rounded-br-\[34px\] {
                border-bottom-right-radius: 34px
            }
            
            .rounded-br-lg {
                border-bottom-right-radius: .5rem
            }
            
            .rounded-br-md {
                border-bottom-right-radius: .375rem
            }
            
            .rounded-br-xl {
                border-bottom-right-radius: .75rem
            }
            
            .rounded-tl-\[34px\] {
                border-top-left-radius: 34px
            }
            
            .rounded-tl-md {
                border-top-left-radius: .375rem
            }
            
            .rounded-tl-none {
                border-top-left-radius: 0
            }
            
            .rounded-tl-sm {
                border-top-left-radius: .125rem
            }
            
            .rounded-tl-xl {
                border-top-left-radius: .75rem
            }
            
            .rounded-tr-\[8px\] {
                border-top-right-radius: 8px
            }
            
            .rounded-tr-lg {
                border-top-right-radius: .5rem
            }
            
            .rounded-tr-md {
                border-top-right-radius: .375rem
            }
            
            .rounded-tr-sm {
                border-top-right-radius: .125rem
            }
            
            .rounded-tr-xl {
                border-top-right-radius: .75rem
            }
            
            .border {
                border-width: 1px
            }
            
            .border-0 {
                border-width: 0px
            }
            
            .border-2 {
                border-width: 2px
            }
            
            .border-\[0\.012rem\] {
                border-width: .012rem
            }
            
            .border-\[1px\] {
                border-width: 1px
            }
            
            .border-b {
                border-bottom-width: 1px
            }
            
            .border-b-0 {
                border-bottom-width: 0px
            }
            
            .border-b-2 {
                border-bottom-width: 2px
            }
            
            .border-b-\[0\.063rem\] {
                border-bottom-width: .063rem
            }
            
            .border-b-\[1px\] {
                border-bottom-width: 1px
            }
            
            .border-l {
                border-left-width: 1px
            }
            
            .border-l-4 {
                border-left-width: 4px
            }
            
            .border-l-\[0\.4rem\] {
                border-left-width: .4rem
            }
            
            .border-l-\[1px\] {
                border-left-width: 1px
            }
            
            .border-r {
                border-right-width: 1px
            }
            
            .border-r-0 {
                border-right-width: 0px
            }
            
            .border-r-\[0\.012rem\] {
                border-right-width: .012rem
            }
            
            .border-r-\[0\.4rem\] {
                border-right-width: .4rem
            }
            
            .border-r-\[1px\] {
                border-right-width: 1px
            }
            
            .border-t {
                border-top-width: 1px
            }
            
            .border-t-\[0\.063rem\] {
                border-top-width: .063rem
            }
            
            .border-t-\[0\.5rem\] {
                border-top-width: .5rem
            }
            
            .border-t-\[1px\] {
                border-top-width: 1px
            }
            
            .border-solid {
                border-style: solid
            }
            
            .border-dashed {
                border-style: dashed
            }
            
            .border-dotted {
                border-style: dotted
            }
            
            .border-none {
                border-style: none
            }
            
            .border-\[\#0181DD\] {
                --tw-border-opacity: 1;
                border-color: rgb(1 129 221 / var(--tw-border-opacity))
            }
            
            .border-\[\#05153f\] {
                --tw-border-opacity: 1;
                border-color: rgb(5 21 63 / var(--tw-border-opacity))
            }
            
            .border-\[\#262626\] {
                --tw-border-opacity: 1;
                border-color: rgb(38 38 38 / var(--tw-border-opacity))
            }
            
            .border-\[\#323639\] {
                --tw-border-opacity: 1;
                border-color: rgb(50 54 57 / var(--tw-border-opacity))
            }
            
            .border-\[\#6d7682\] {
                --tw-border-opacity: 1;
                border-color: rgb(109 118 130 / var(--tw-border-opacity))
            }
            
            .border-\[\#808080\] {
                --tw-border-opacity: 1;
                border-color: rgb(128 128 128 / var(--tw-border-opacity))
            }
            
            .border-\[\#9da1ae\] {
                --tw-border-opacity: 1;
                border-color: rgb(157 161 174 / var(--tw-border-opacity))
            }
            
            .border-\[\#D9D9D9\] {
                --tw-border-opacity: 1;
                border-color: rgb(217 217 217 / var(--tw-border-opacity))
            }
            
            .border-\[\#cbcccc\] {
                --tw-border-opacity: 1;
                border-color: rgb(203 204 204 / var(--tw-border-opacity))
            }
            
            .border-\[\#ced4da\] {
                --tw-border-opacity: 1;
                border-color: rgb(206 212 218 / var(--tw-border-opacity))
            }
            
            .border-\[\#d1d9e3\] {
                --tw-border-opacity: 1;
                border-color: rgb(209 217 227 / var(--tw-border-opacity))
            }
            
            .border-\[\#f89923\] {
                --tw-border-opacity: 1;
                border-color: rgb(248 153 35 / var(--tw-border-opacity))
            }
            
            .border-\[rgba\(0\,0\,0\,\.125\)\] {
                border-color: #00000020
            }
            
            .border-black {
                --tw-border-opacity: 1;
                border-color: rgb(0 0 0 / var(--tw-border-opacity))
            }
            
            .border-black\/20 {
                border-color: #0003
            }
            
            .border-black\/30 {
                border-color: #0000004d
            }
            
            .border-black\/40 {
                border-color: #0006
            }
            
            .border-blue-200 {
                --tw-border-opacity: 1;
                border-color: rgb(191 219 254 / var(--tw-border-opacity))
            }
            
            .border-blue-400 {
                --tw-border-opacity: 1;
                border-color: rgb(96 165 250 / var(--tw-border-opacity))
            }
            
            .border-blue-500 {
                border-color: rgb(59 130 246)
            }
            
            .border-gray-100 {
                --tw-border-opacity: 1;
                border-color: rgb(243 244 246 / var(--tw-border-opacity))
            }
            
            .border-gray-200 {
                --tw-border-opacity: 1;
                border-color: rgb(229 231 235 / var(--tw-border-opacity))
            }
            
            .border-gray-300 {
                --tw-border-opacity: 1;
                border-color: rgb(209 213 219)
            }
            
            .border-gray-400 {
                --tw-border-opacity: 1;
                border-color: rgb(156 163 175 / var(--tw-border-opacity))
            }
            
            .border-gray-500 {
                --tw-border-opacity: 1;
                border-color: rgb(107 114 128 / var(--tw-border-opacity))
            }
            
            .border-gray-700 {
                --tw-border-opacity: 1;
                border-color: rgb(55 65 81 / var(--tw-border-opacity))
            }
            
            .border-green-600 {
                --tw-border-opacity: 1;
                border-color: rgb(22 163 74 / var(--tw-border-opacity))
            }
            
            .border-indigo-200 {
                --tw-border-opacity: 1;
                border-color: rgb(199 210 254 / var(--tw-border-opacity))
            }
            
            .border-indigo-400 {
                --tw-border-opacity: 1;
                border-color: rgb(129 140 248 / var(--tw-border-opacity))
            }
            
            .border-rGTBorderColor {
                border-color: var(--rGTBorderColor)
            }
            
            .border-red-300 {
                --tw-border-opacity: 1;
                border-color: rgb(252 165 165 / var(--tw-border-opacity))
            }
            
            .border-red-400 {
                --tw-border-opacity: 1;
                border-color: rgb(248 113 113 / var(--tw-border-opacity))
            }
            
            .border-red-500 {
                --tw-border-opacity: 1;
                border-color: rgb(239 68 68 / var(--tw-border-opacity))
            }
            
            .border-slate-300 {
                --tw-border-opacity: 1;
                border-color: rgb(203 213 225 / var(--tw-border-opacity))
            }
            
            .border-transparent {
                border-color: transparent
            }
            
            .border-white {
                --tw-border-opacity: 1;
                border-color: rgb(255 255 255 / var(--tw-border-opacity))
            }
            
            .border-zinc-400 {
                --tw-border-opacity: 1;
                border-color: rgb(161 161 170 / var(--tw-border-opacity))
            }
            
            .border-b-transparent {
                border-bottom-color: transparent
            }
            
            .border-l-transparent {
                border-left-color: transparent
            }
            
            .border-r-transparent {
                border-right-color: transparent
            }
            
            .bg-\[\#006ee31c\] {
                background-color: #006ee31c
            }
            
            .bg-\[\#006ee3\] {
                --tw-bg-opacity: 1;
                background-color: rgb(0 110 227 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#008A04\] {
                --tw-bg-opacity: 1;
                background-color: rgb(0 138 4 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#0181dd\] {
                --tw-bg-opacity: 1;
                background-color: rgb(1 129 221 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#036dc3\] {
                --tw-bg-opacity: 1;
                background-color: rgb(3 109 195 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#0d6efd\] {
                --tw-bg-opacity: 1;
                background-color: rgb(13 110 253 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#128c7e\] {
                --tw-bg-opacity: 1;
                background-color: rgb(18 140 126 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#2196F3\] {
                --tw-bg-opacity: 1;
                background-color: rgb(33 150 243 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#25D366\] {
                --tw-bg-opacity: 1;
                background-color: rgb(37 211 102 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#3eb991\] {
                --tw-bg-opacity: 1;
                background-color: rgb(62 185 145 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#c13584\] {
                --tw-bg-opacity: 1;
                background-color: rgb(193 53 132 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#d6e4f1\] {
                --tw-bg-opacity: 1;
                background-color: rgb(214 228 241 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#f1f5f8\] {
                --tw-bg-opacity: 1;
                background-color: rgb(241 245 248 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#f3f3f3\] {
                --tw-bg-opacity: 1;
                background-color: rgb(243 243 243 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#f899231c\] {
                background-color: #f899231c
            }
            
            .bg-\[\#f9f9fa\] {
                --tw-bg-opacity: 1;
                background-color: rgb(249 249 250 / var(--tw-bg-opacity))
            }
            
            .bg-\[\#fafafa\] {
                --tw-bg-opacity: 1;
                background-color: rgb(250 250 250 / var(--tw-bg-opacity))
            }
            
            .bg-bgRGTBaseColor {
                background-color: var(--bgRGTBaseColor)
            }
            
            .bg-black {
                --tw-bg-opacity: 1;
                background-color: rgb(0 0 0 / var(--tw-bg-opacity))
            }
            
            .bg-black\/20 {
                background-color: #0003
            }
            
            .bg-blue-100 {
                --tw-bg-opacity: 1;
                background-color: rgb(219 234 254 / var(--tw-bg-opacity))
            }
            
            .bg-blue-500 {
                --tw-bg-opacity: 1;
                background-color: rgb(59 130 246)
            }
            
            .bg-blue-600 {
                --tw-bg-opacity: 1;
                background-color: rgb(37 99 235)
            }
            
            .bg-blue-700 {
                --tw-bg-opacity: 1;
                background-color: rgb(29 78 216 / var(--tw-bg-opacity))
            }
            
            .bg-gray-100 {
                --tw-bg-opacity: 1;
                background-color: rgb(243 244 246 / var(--tw-bg-opacity))
            }
            
            .bg-gray-200 {
                background-color: rgb(229 231 235)
            }
            
            .bg-gray-50 {
                --tw-bg-opacity: 1;
                background-color: rgb(249 250 251 / var(--tw-bg-opacity))
            }
            
            .bg-gray-500 {
                --tw-bg-opacity: 1;
                background-color: rgb(107 114 128 / var(--tw-bg-opacity))
            }
            
            .bg-gray-800 {
                --tw-bg-opacity: 1;
                background-color: rgb(31 41 55 / var(--tw-bg-opacity))
            }
            
            .bg-gray-900 {
                --tw-bg-opacity: 1;
                background-color: rgb(17 24 39 / var(--tw-bg-opacity))
            }
            
            .bg-green-500 {
                --tw-bg-opacity: 1;
                background-color: rgb(34 197 94 / var(--tw-bg-opacity))
            }
            
            .bg-green-600 {
                --tw-bg-opacity: 1;
                background-color: rgb(22 163 74 / var(--tw-bg-opacity))
            }
            
            .bg-green-700 {
                --tw-bg-opacity: 1;
                background-color: rgb(21 128 61 / var(--tw-bg-opacity))
            }
            
            .bg-indigo-50 {
                --tw-bg-opacity: 1;
                background-color: rgb(238 242 255 / var(--tw-bg-opacity))
            }
            
            .bg-indigo-600 {
                --tw-bg-opacity: 1;
                background-color: rgb(79 70 229 / var(--tw-bg-opacity))
            }
            
            .bg-rGTBaseTextColor {
                background-color: var(--rGTBaseTextColor)
            }
            
            .bg-rGTBorderColor {
                background-color: var(--rGTBorderColor)
            }
            
            .bg-red-50 {
                --tw-bg-opacity: 1;
                background-color: rgb(254 242 242 / var(--tw-bg-opacity))
            }
            
            .bg-red-500 {
                --tw-bg-opacity: 1;
                background-color: rgb(239 68 68 / var(--tw-bg-opacity))
            }
            
            .bg-red-600 {
                background-color: rgb(220 38 38)
            }
            
            .bg-red-700 {
                --tw-bg-opacity: 1;
                background-color: rgb(185 28 28 / var(--tw-bg-opacity))
            }
            
            .bg-slate-200 {
                --tw-bg-opacity: 1;
                background-color: rgb(226 232 240 / var(--tw-bg-opacity))
            }
            
            .bg-transparent {
                background-color: transparent
            }
            
            .bg-white {
                --tw-bg-opacity: 1;
                background-color: rgb(255 255 255)
            }
            
            .bg-yellow-200 {
                --tw-bg-opacity: 1;
                background-color: rgb(254 240 138 / var(--tw-bg-opacity))
            }
            
            .bg-yellow-500 {
                --tw-bg-opacity: 1;
                background-color: rgb(234 179 8 / var(--tw-bg-opacity))
            }
            
            .bg-opacity-75 {
                --tw-bg-opacity: .75
            }
            
            .fill-current {
                fill: currentColor
            }
            
            .object-cover {
                -o-object-fit: cover;
                object-fit: cover
            }
            
            .object-center {
                -o-object-position: center;
                object-position: center
            }
            
            .p-0 {
                padding: 0
            }
            
            .p-1 {
                padding: .25rem
            }
            
            .p-2 {
                padding: .5rem
            }
            
            .p-2\.5 {
                padding: .625rem
            }
            
            .p-3 {
                padding: .75rem
            }
            
            .p-4 {
                padding: 1rem
            }
            
            .p-5 {
                padding: 1.25rem
            }
            
            .p-6 {
                padding: 1.5rem
            }
            
            .p-8 {
                padding: 2rem
            }
            
            .p-\[0px_15px\] {
                padding: 0 15px
            }
            
            .p-\[0px_4px_0px_4px\] {
                padding: 0 4px
            }
            
            .p-\[0rem_0\.7rem\] {
                padding: 0rem .7rem
            }
            
            .p-\[1rem_1rem\] {
                padding: 1rem
            }
            
            .p-\[4px_10px_4px_10px\] {
                padding: 4px 10px
            }
            
            .p-\[5px_0px\] {
                padding: 5px 0
            }
            
            .p-\[5px_0px_4px_0px\] {
                padding: 5px 0 4px
            }
            
            .p-\[6px_6px_6px\] {
                padding: 6px
            }
            
            .p-\[8px_15px\] {
                padding: 8px 15px
            }
            
            .px-0 {
                padding-left: 0;
                padding-right: 0
            }
            
            .px-1 {
                padding-left: .25rem;
                padding-right: .25rem
            }
            
            .px-2 {
                padding-left: .5rem;
                padding-right: .5rem
            }
            
            .px-2\.5 {
                padding-left: .625rem;
                padding-right: .625rem
            }
            
            .px-24 {
                padding-left: 6rem;
                padding-right: 6rem
            }
            
            .px-3 {
                padding-left: .75rem;
                padding-right: .75rem
            }
            
            .px-4 {
                padding-left: 1rem;
                padding-right: 1rem
            }
            
            .px-5 {
                padding-left: 1.25rem;
                padding-right: 1.25rem
            }
            
            .px-6 {
                padding-left: 1.5rem;
                padding-right: 1.5rem
            }
            
            .px-9 {
                padding-left: 2.25rem;
                padding-right: 2.25rem
            }
            
            .px-\[0\.7rem\] {
                padding-left: .7rem;
                padding-right: .7rem
            }
            
            .py-0 {
                padding-top: 0;
                padding-bottom: 0
            }
            
            .py-0\.5 {
                padding-top: .125rem;
                padding-bottom: .125rem
            }
            
            .py-1 {
                padding-top: .25rem;
                padding-bottom: .25rem
            }
            
            .py-12 {
                padding-top: 3rem;
                padding-bottom: 3rem
            }
            
            .py-16 {
                padding-top: 4rem;
                padding-bottom: 4rem
            }
            
            .py-2 {
                padding-top: .5rem;
                padding-bottom: .5rem
            }
            
            .py-2\.5 {
                padding-top: .625rem;
                padding-bottom: .625rem
            }
            
            .py-20 {
                padding-top: 5rem;
                padding-bottom: 5rem
            }
            
            .py-28 {
                padding-top: 7rem;
                padding-bottom: 7rem
            }
            
            .py-3 {
                padding-top: .75rem;
                padding-bottom: .75rem
            }
            
            .py-4 {
                padding-top: 1rem;
                padding-bottom: 1rem
            }
            
            .py-5 {
                padding-top: 1.25rem;
                padding-bottom: 1.25rem
            }
            
            .py-6 {
                padding-top: 1.5rem;
                padding-bottom: 1.5rem
            }
            
            .py-\[0\.15rem\] {
                padding-top: .15rem;
                padding-bottom: .15rem
            }
            
            .py-\[0\.32rem\] {
                padding-top: .32rem;
                padding-bottom: .32rem
            }
            
            .py-\[0\.83rem\] {
                padding-top: .83rem;
                padding-bottom: .83rem
            }
            
            .py-\[02px\] {
                padding-top: 02px;
                padding-bottom: 02px
            }
            
            .py-\[6px\] {
                padding-top: 6px;
                padding-bottom: 6px
            }
            
            .pb-0 {
                padding-bottom: 0
            }
            
            .pb-1 {
                padding-bottom: .25rem
            }
            
            .pb-12 {
                padding-bottom: 3rem
            }
            
            .pb-2 {
                padding-bottom: .5rem
            }
            
            .pb-2\.5 {
                padding-bottom: .625rem
            }
            
            .pb-3 {
                padding-bottom: .75rem
            }
            
            .pb-4 {
                padding-bottom: 1rem
            }
            
            .pb-5 {
                padding-bottom: 1.25rem
            }
            
            .pb-6 {
                padding-bottom: 1.5rem
            }
            
            .pe-2 {
                padding-inline-end:.5rem}
            
            .pe-3 {
                padding-inline-end:.75rem}
            
            .pl-1 {
                padding-left: .25rem
            }
            
            .pl-10 {
                padding-left: 2.5rem
            }
            
            .pl-14 {
                padding-left: 3.5rem
            }
            
            .pl-2 {
                padding-left: .5rem
            }
            
            .pl-2\.5 {
                padding-left: .625rem
            }
            
            .pl-3 {
                padding-left: .75rem
            }
            
            .pl-4 {
                padding-left: 1rem
            }
            
            .pl-5 {
                padding-left: 1.25rem
            }
            
            .pl-6 {
                padding-left: 1.5rem
            }
            
            .pl-7 {
                padding-left: 1.75rem
            }
            
            .pl-8 {
                padding-left: 2rem
            }
            
            .pl-\[14px\] {
                padding-left: 14px
            }
            
            .pr-1 {
                padding-right: .25rem
            }
            
            .pr-12 {
                padding-right: 3rem
            }
            
            .pr-2 {
                padding-right: .5rem
            }
            
            .pr-3 {
                padding-right: .75rem
            }
            
            .pr-4 {
                padding-right: 1rem
            }
            
            .pr-6 {
                padding-right: 1.5rem
            }
            
            .pr-7 {
                padding-right: 1.75rem
            }
            
            .ps-3 {
                padding-inline-start:.75rem}
            
            .pt-1 {
                padding-top: .25rem
            }
            
            .pt-2 {
                padding-top: .5rem
            }
            
            .pt-3 {
                padding-top: .75rem
            }
            
            .pt-4 {
                padding-top: 1rem
            }
            
            .pt-5 {
                padding-top: 1.25rem
            }
            
            .pt-8 {
                padding-top: 2rem
            }
            
            .text-left {
                text-align: left
            }
            
            .text-center {
                text-align: center
            }
            
            .text-right {
                text-align: right
            }
            
            .text-justify {
                text-align: justify
            }
            
            .text-start {
                text-align: start
            }
            
            .text-end {
                text-align: end
            }
            
            .align-baseline {
                vertical-align: baseline
            }
            
            .align-top {
                vertical-align: top
            }
            
            .align-middle {
                vertical-align: middle
            }
            
            .font-sans {
                font-family: Jost,ui-sans-serif,system-ui,sans-serif,"Apple Color Emoji","Segoe UI Emoji",Segoe UI Symbol,"Noto Color Emoji"
            }
            
            .text-2xl {
                font-size: 1.5rem;
                line-height: 2rem
            }
            
            .text-3xl {
                font-size: 1.875rem;
                line-height: 2.25rem
            }
            
            .text-4xl {
                font-size: 2.25rem;
                line-height: 2.5rem
            }
            
            .text-\[1\.125rem\] {
                font-size: 1.125rem
            }
            
            .text-\[1\.1rem\] {
                font-size: 1.1rem
            }
            
            .text-\[10px\] {
                font-size: 10px
            }
            
            .text-\[11px\] {
                font-size: 11px
            }
            
            .text-\[12px\] {
                font-size: 12px
            }
            
            .text-\[13px\] {
                font-size: 13px
            }
            
            .text-\[14px\] {
                font-size: 14px
            }
            
            .text-\[15px\] {
                font-size: 15px
            }
            
            .text-\[1rem\] {
                font-size: 1rem
            }
            
            .text-\[20px\] {
                font-size: 20px
            }
            
            .text-\[22px\] {
                font-size: 22px
            }
            
            .text-\[29px\] {
                font-size: 29px
            }
            
            .text-\[2rem\] {
                font-size: 2rem
            }
            
            .text-\[30px\] {
                font-size: 30px
            }
            
            .text-\[8px\] {
                font-size: 8px
            }
            
            .text-\[9px\] {
                font-size: 9px
            }
            
            .text-base {
                font-size: 1rem;
                line-height: 1.5rem
            }
            
            .text-lg {
                font-size: 1.125rem;
                line-height: 1.75rem
            }
            
            .text-sm {
                font-size: .875rem;
                line-height: 1.25rem
            }
            
            .text-xl {
                font-size: 1.25rem;
                line-height: 1.75rem
            }
            
            .text-xs {
                font-size: .75rem;
                line-height: 1rem
            }
            
            .font-\[400\] {
                font-weight: 400
            }
            
            .font-bold {
                font-weight: 700
            }
            
            .font-extrabold {
                font-weight: 800
            }
            
            .font-extralight {
                font-weight: 200
            }
            
            .font-light {
                font-weight: 300
            }
            
            .font-medium {
                font-weight: 500
            }
            
            .font-normal {
                font-weight: 400
            }
            
            .font-semibold {
                font-weight: 600
            }
            
            .uppercase {
                text-transform: uppercase
            }
            
            .lowercase {
                text-transform: lowercase
            }
            
            .capitalize {
                text-transform: capitalize
            }
            
            .italic {
                font-style: italic
            }
            
            .leading-10 {
                line-height: 2.5rem
            }
            
            .leading-4 {
                line-height: 1rem
            }
            
            .leading-5 {
                line-height: 1.25rem
            }
            
            .leading-6 {
                line-height: 1.5rem
            }
            
            .leading-7 {
                line-height: 1.75rem
            }
            
            .leading-\[1\.2\] {
                line-height: 1.2
            }
            
            .leading-\[1\.50rem\] {
                line-height: 1.5rem
            }
            
            .leading-\[1\.7\] {
                line-height: 1.7
            }
            
            .leading-\[2\.875rem\] {
                line-height: 2.875rem
            }
            
            .leading-normal {
                line-height: 1.5
            }
            
            .leading-relaxed {
                line-height: 1.625
            }
            
            .leading-tight {
                line-height: 1.25
            }
            
            .tracking-tight {
                letter-spacing: -.025em
            }
            
            .tracking-wide {
                letter-spacing: .025em
            }
            
            .tracking-wider {
                letter-spacing: .05em
            }
            
            .tracking-widest {
                letter-spacing: .1em
            }
            
            .text-\[\#000000D9\] {
                color: #000000d9
            }
            
            .text-\[\#006ee3\] {
                --tw-text-opacity: 1;
                color: rgb(0 110 227 / var(--tw-text-opacity))
            }
            
            .text-\[\#0081f3\] {
                --tw-text-opacity: 1;
                color: rgb(0 129 243 / var(--tw-text-opacity))
            }
            
            .text-\[\#008A04\] {
                --tw-text-opacity: 1;
                color: rgb(0 138 4 / var(--tw-text-opacity))
            }
            
            .text-\[\#0181dd\] {
                --tw-text-opacity: 1;
                color: rgb(1 129 221 / var(--tw-text-opacity))
            }
            
            .text-\[\#05264e\] {
                --tw-text-opacity: 1;
                color: rgb(5 38 78 / var(--tw-text-opacity))
            }
            
            .text-\[\#08437D\] {
                --tw-text-opacity: 1;
                color: rgb(8 67 125 / var(--tw-text-opacity))
            }
            
            .text-\[\#0a549c\] {
                --tw-text-opacity: 1;
                color: rgb(10 84 156 / var(--tw-text-opacity))
            }
            
            .text-\[\#0d6efd\] {
                --tw-text-opacity: 1;
                color: rgb(13 110 253 / var(--tw-text-opacity))
            }
            
            .text-\[\#25D366\] {
                --tw-text-opacity: 1;
                color: rgb(37 211 102 / var(--tw-text-opacity))
            }
            
            .text-\[\#2E312F\] {
                --tw-text-opacity: 1;
                color: rgb(46 49 47 / var(--tw-text-opacity))
            }
            
            .text-\[\#313541\] {
                --tw-text-opacity: 1;
                color: rgb(49 53 65 / var(--tw-text-opacity))
            }
            
            .text-\[\#ADB5BD\] {
                --tw-text-opacity: 1;
                color: rgb(173 181 189 / var(--tw-text-opacity))
            }
            
            .text-\[\#f89923\] {
                --tw-text-opacity: 1;
                color: rgb(248 153 35 / var(--tw-text-opacity))
            }
            
            .text-\[\#fb710e\] {
                --tw-text-opacity: 1;
                color: rgb(251 113 14 / var(--tw-text-opacity))
            }
            
            .text-\[white\] {
                --tw-text-opacity: 1;
                color: rgb(255 255 255 / var(--tw-text-opacity))
            }
            
            .text-amber-950 {
                --tw-text-opacity: 1;
                color: rgb(69 26 3 / var(--tw-text-opacity))
            }
            
            .text-black {
                --tw-text-opacity: 1;
                color: rgb(0 0 0 / var(--tw-text-opacity))
            }
            
            .text-blue-400 {
                --tw-text-opacity: 1;
                color: rgb(96 165 250 / var(--tw-text-opacity))
            }
            
            .text-blue-500 {
                --tw-text-opacity: 1;
                color: rgb(59 130 246 / var(--tw-text-opacity))
            }
            
            .text-blue-600 {
                --tw-text-opacity: 1;
                color: rgb(37 99 235 / var(--tw-text-opacity))
            }
            
            .text-blue-800 {
                --tw-text-opacity: 1;
                color: rgb(30 64 175 / var(--tw-text-opacity))
            }
            
            .text-gray-100 {
                --tw-text-opacity: 1;
                color: rgb(243 244 246 / var(--tw-text-opacity))
            }
            
            .text-gray-200 {
                --tw-text-opacity: 1;
                color: rgb(229 231 235 / var(--tw-text-opacity))
            }
            
            .text-gray-300 {
                --tw-text-opacity: 1;
                color: rgb(209 213 219 / var(--tw-text-opacity))
            }
            
            .text-gray-400 {
                --tw-text-opacity: 1;
                color: rgb(156 163 175 / var(--tw-text-opacity))
            }
            
            .text-gray-500 {
                --tw-text-opacity: 1;
                color: rgb(107 114 128 / var(--tw-text-opacity))
            }
            
            .text-gray-600 {
                --tw-text-opacity: 1;
                color: rgb(75 85 99 / var(--tw-text-opacity))
            }
            
            .text-gray-700 {
                --tw-text-opacity: 1;
                color: rgb(55 65 81 / var(--tw-text-opacity))
            }
            
            .text-gray-800 {
                --tw-text-opacity: 1;
                color: rgb(31 41 55 / var(--tw-text-opacity))
            }
            
            .text-gray-900 {
                --tw-text-opacity: 1;
                color: rgb(17 24 39 / var(--tw-text-opacity))
            }
            
            .text-green-400 {
                --tw-text-opacity: 1;
                color: rgb(74 222 128 / var(--tw-text-opacity))
            }
            
            .text-green-500 {
                --tw-text-opacity: 1;
                color: rgb(34 197 94 / var(--tw-text-opacity))
            }
            
            .text-green-600 {
                --tw-text-opacity: 1;
                color: rgb(22 163 74 / var(--tw-text-opacity))
            }
            
            .text-indigo-600 {
                --tw-text-opacity: 1;
                color: rgb(79 70 229 / var(--tw-text-opacity))
            }
            
            .text-indigo-700 {
                --tw-text-opacity: 1;
                color: rgb(67 56 202 / var(--tw-text-opacity))
            }
            
            .text-orange-400 {
                --tw-text-opacity: 1;
                color: rgb(251 146 60 / var(--tw-text-opacity))
            }
            
            .text-orange-500 {
                --tw-text-opacity: 1;
                color: rgb(249 115 22 / var(--tw-text-opacity))
            }
            
            .text-rGTBaseTextColor {
                color: var(--rGTBaseTextColor)
            }
            
            .text-red-100 {
                --tw-text-opacity: 1;
                color: rgb(254 226 226 / var(--tw-text-opacity))
            }
            
            .text-red-400 {
                --tw-text-opacity: 1;
                color: rgb(248 113 113 / var(--tw-text-opacity))
            }
            
            .text-red-500 {
                --tw-text-opacity: 1;
                color: rgb(239 68 68 / var(--tw-text-opacity))
            }
            
            .text-red-600 {
                --tw-text-opacity: 1;
                color: rgb(220 38 38 / var(--tw-text-opacity))
            }
            
            .text-red-700 {
                --tw-text-opacity: 1;
                color: rgb(185 28 28 / var(--tw-text-opacity))
            }
            
            .text-red-900 {
                --tw-text-opacity: 1;
                color: rgb(127 29 29 / var(--tw-text-opacity))
            }
            
            .text-textWhite {
                color: var(--textWhite)
            }
            
            .text-txtColor {
                color: var(--color-txt-color)
            }
            
            .text-white {
                color: rgb(255 255 255)
            }
            
            .text-yellow-500 {
                --tw-text-opacity: 1;
                color: rgb(234 179 8 / var(--tw-text-opacity))
            }
            
            .text-zinc-400 {
                --tw-text-opacity: 1;
                color: rgb(161 161 170 / var(--tw-text-opacity))
            }
            
            .text-zinc-600 {
                --tw-text-opacity: 1;
                color: rgb(82 82 91 / var(--tw-text-opacity))
            }
            
            .text-zinc-700 {
                --tw-text-opacity: 1;
                color: rgb(63 63 70 / var(--tw-text-opacity))
            }
            
            .text-zinc-900 {
                --tw-text-opacity: 1;
                color: rgb(24 24 27 / var(--tw-text-opacity))
            }
            
            .underline {
                text-decoration-line: underline
            }
            
            .antialiased {
                -webkit-font-smoothing: antialiased;
                -moz-osx-font-smoothing: grayscale
            }
            
            .opacity-0 {
                opacity: 0
            }
            
            .opacity-100 {
                opacity: 1
            }
            
            .opacity-25 {
                opacity: .25
            }
            
            .opacity-75 {
                opacity: .75
            }
            
            .shadow {
                --tw-shadow: 0 1px 3px 0 rgb(0 0 0 / .1), 0 1px 2px -1px rgb(0 0 0 / .1);
                --tw-shadow-colored: 0 1px 3px 0 var(--tw-shadow-color), 0 1px 2px -1px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-2xl {
                --tw-shadow: 0 25px 50px -12px rgb(0 0 0 / .25);
                --tw-shadow-colored: 0 25px 50px -12px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[-2px_-4px_8px_-2px_\#cdcdcd\] {
                --tw-shadow: -2px -4px 8px -2px #cdcdcd;
                --tw-shadow-colored: -2px -4px 8px -2px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[-2px_1px_5px_0px_\#e9e9e9\] {
                --tw-shadow: -2px 1px 5px 0px #e9e9e9;
                --tw-shadow-colored: -2px 1px 5px 0px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[-4px_1px_8px_3px_\#95959561\] {
                --tw-shadow: -4px 1px 8px 3px #95959561;
                --tw-shadow-colored: -4px 1px 8px 3px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_0_10px_rgb\(119_119_119\/21\%\)\] {
                --tw-shadow: 0 0 10px rgb(119 119 119/21%);
                --tw-shadow-colored: 0 0 10px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_0_4px_1px_\#a69a9a\] {
                --tw-shadow: 0 0 4px 1px #a69a9a;
                --tw-shadow-colored: 0 0 4px 1px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_1px_3px_0px_rgba\(0\,0\,0\,0\.3\)\] {
                --tw-shadow: 0 1px 3px 0px rgba(0,0,0,.3);
                --tw-shadow-colored: 0 1px 3px 0px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_2px_4px_0_rgb\(0_0_0_\/_10\%\)\] {
                --tw-shadow: 0 2px 4px 0 rgb(0 0 0 / 10%);
                --tw-shadow-colored: 0 2px 4px 0 var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_2px_5px_rgba\(0_0_0_0\.3\)\] {
                --tw-shadow: 0 2px 5px rgba(0 0 0 .3);
                --tw-shadow-colored: 0 2px 5px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_35px_60px_-15px_rgba\(50_50_105_0\.15\)\,0px_1px_1px_0p_rgba\(0_0_0_0\.05\)\] {
                --tw-shadow: 0 35px 60px -15px rgba(50 50 105 .15),0px 1px 1px 0p rgba(0 0 0 .05);
                --tw-shadow-colored: 0 35px 60px -15px var(--tw-shadow-color), 0px 1px 1px 0p var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_35px_60px_-15px_rgba\(50_50_105_0\.15\)\] {
                --tw-shadow: 0 35px 60px -15px rgba(50 50 105 .15);
                --tw-shadow-colored: 0 35px 60px -15px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_3px_10px_rgb\(0\,0\,0\,0\.2\)\] {
                --tw-shadow: 0 3px 10px rgb(0,0,0,.2);
                --tw-shadow-colored: 0 3px 10px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0_5px_4px_0_rgba\(0\,0\,0\,\.26\)\] {
                --tw-shadow: 0 5px 4px 0 rgba(0,0,0,.26);
                --tw-shadow-colored: 0 5px 4px 0 var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0px_0px_6px_1px_\#4e4e4e\] {
                --tw-shadow: 0px 0px 6px 1px #4e4e4e;
                --tw-shadow-colored: 0px 0px 6px 1px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0px_2px_6px_0px_\#383838\] {
                --tw-shadow: 0px 2px 6px 0px #383838;
                --tw-shadow-colored: 0px 2px 6px 0px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[0px_3px_9px_0px_\#f3f3f3\] {
                --tw-shadow: 0px 3px 9px 0px #f3f3f3;
                --tw-shadow-colored: 0px 3px 9px 0px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-\[4px_2px_8px_0px_\#a3a3a3d6\] {
                --tw-shadow: 4px 2px 8px 0px #a3a3a3d6;
                --tw-shadow-colored: 4px 2px 8px 0px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-lg {
                --tw-shadow: 0 10px 15px -3px rgb(0 0 0 / .1), 0 4px 6px -4px rgb(0 0 0 / .1);
                --tw-shadow-colored: 0 10px 15px -3px var(--tw-shadow-color), 0 4px 6px -4px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-md {
                --tw-shadow: 0 4px 6px -1px rgb(0 0 0 / .1), 0 2px 4px -2px rgb(0 0 0 / .1);
                --tw-shadow-colored: 0 4px 6px -1px var(--tw-shadow-color), 0 2px 4px -2px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-sm {
                --tw-shadow: 0 1px 2px 0 rgb(0 0 0 / .05);
                --tw-shadow-colored: 0 1px 2px 0 var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-xl {
                --tw-shadow: 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1);
                --tw-shadow-colored: 0 20px 25px -5px var(--tw-shadow-color), 0 8px 10px -6px var(--tw-shadow-color);
                box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000),var(--tw-ring-shadow, 0 0 #0000),var(--tw-shadow)
            }
            
            .shadow-gray-900\/10 {
                --tw-shadow-color: rgb(17 24 39 / .1);
                --tw-shadow: var(--tw-shadow-colored)
            }
            
            .outline-none {
                outline: 2px solid transparent;
                outline-offset: 2px
            }
            
            .ring {
                --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
                --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(3px + var(--tw-ring-offset-width)) var(--tw-ring-color);
                box-shadow: var(--tw-ring-offset-shadow),var(--tw-ring-shadow),var(--tw-shadow, 0 0 #0000)
            }
            
            .ring-0 {
                --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
                --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(0px + var(--tw-ring-offset-width)) var(--tw-ring-color);
                box-shadow: var(--tw-ring-offset-shadow),var(--tw-ring-shadow),var(--tw-shadow, 0 0 #0000)
            }
            
            .ring-1 {
                --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
                --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color);
                box-shadow: var(--tw-ring-offset-shadow),var(--tw-ring-shadow),var(--tw-shadow, 0 0 #0000)
            }
            
            .ring-inset {
                --tw-ring-inset: inset
            }
            
            .ring-black {
                --tw-ring-opacity: 1;
                --tw-ring-color: rgb(0 0 0 / var(--tw-ring-opacity))
            }
            
            .ring-gray-300 {
                --tw-ring-opacity: 1;
                --tw-ring-color: rgb(209 213 219 / var(--tw-ring-opacity))
            }
            
            .ring-indigo-600\/50 {
                --tw-ring-color: rgb(79 70 229 / .5)
            }
            
            .ring-opacity-5 {
                --tw-ring-opacity: .05
            }
            
            .brightness-75 {
                --tw-brightness: brightness(.75);
                filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale) var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia) var(--tw-drop-shadow)
            }
            
            .drop-shadow {
                --tw-drop-shadow: drop-shadow(0 1px 2px rgb(0 0 0 / .1)) drop-shadow(0 1px 1px rgb(0 0 0 / .06));
                filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale) var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia) var(--tw-drop-shadow)
            }
            
            .drop-shadow-\[2px_2px_1px_black\] {
                --tw-drop-shadow: drop-shadow(2px 2px 1px black);
                filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale) var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia) var(--tw-drop-shadow)
            }
            
            .drop-shadow-\[2px_2px_2px_gray\] {
                --tw-drop-shadow: drop-shadow(2px 2px 2px gray);
                filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale) var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia) var(--tw-drop-shadow)
            }
            
            .filter {
                filter: var(--tw-blur) var(--tw-brightness) var(--tw-contrast) var(--tw-grayscale) var(--tw-hue-rotate) var(--tw-invert) var(--tw-saturate) var(--tw-sepia) var(--tw-drop-shadow)
            }
            
            .backdrop-blur-xl {
                --tw-backdrop-blur: blur(24px);
                -webkit-backdrop-filter: var(--tw-backdrop-blur) var(--tw-backdrop-brightness) var(--tw-backdrop-contrast) var(--tw-backdrop-grayscale) var(--tw-backdrop-hue-rotate) var(--tw-backdrop-invert) var(--tw-backdrop-opacity) var(--tw-backdrop-saturate) var(--tw-backdrop-sepia);
                backdrop-filter: var(--tw-backdrop-blur) var(--tw-backdrop-brightness) var(--tw-backdrop-contrast) var(--tw-backdrop-grayscale) var(--tw-backdrop-hue-rotate) var(--tw-backdrop-invert) var(--tw-backdrop-opacity) var(--tw-backdrop-saturate) var(--tw-backdrop-sepia)
            }
            
            .backdrop-brightness-150 {
                --tw-backdrop-brightness: brightness(1.5);
                -webkit-backdrop-filter: var(--tw-backdrop-blur) var(--tw-backdrop-brightness) var(--tw-backdrop-contrast) var(--tw-backdrop-grayscale) var(--tw-backdrop-hue-rotate) var(--tw-backdrop-invert) var(--tw-backdrop-opacity) var(--tw-backdrop-saturate) var(--tw-backdrop-sepia);
                backdrop-filter: var(--tw-backdrop-blur) var(--tw-backdrop-brightness) var(--tw-backdrop-contrast) var(--tw-backdrop-grayscale) var(--tw-backdrop-hue-rotate) var(--tw-backdrop-invert) var(--tw-backdrop-opacity) var(--tw-backdrop-saturate) var(--tw-backdrop-sepia)
            }
            
            .transition {
                transition-property: color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,-webkit-backdrop-filter;
                transition-property: color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter;
                transition-property: color,background-color,border-color,text-decoration-color,fill,stroke,opacity,box-shadow,transform,filter,backdrop-filter,-webkit-backdrop-filter;
                transition-timing-function: cubic-bezier(.4,0,.2,1);
                transition-duration: .15s
            }
            
            .transition-all {
                transition-property: all;
                transition-timing-function: cubic-bezier(.4,0,.2,1);
                transition-duration: .15s
            }
            
            .transition-colors {
                transition-property: color,background-color,border-color,text-decoration-color,fill,stroke;
                transition-timing-function: cubic-bezier(.4,0,.2,1);
                transition-duration: .15s
            }
            
            .transition-opacity {
                transition-property: opacity;
                transition-timing-function: cubic-bezier(.4,0,.2,1);
                transition-duration: .15s
            }
            
            .delay-700 {
                transition-delay: .7s
            }
            
            .duration-1000 {
                transition-duration: 1s
            }
            
            .duration-150 {
                transition-duration: .15s
            }
            
            .duration-200 {
                transition-duration: .2s
            }
            
            .duration-300 {
                transition-duration: .3s
            }
            
            .duration-500 {
                transition-duration: .5s
            }
            
            .duration-700 {
                transition-duration: .7s
            }
            
            .duration-75 {
                transition-duration: 75ms
            }
            
            .ease-in {
                transition-timing-function: cubic-bezier(.4,0,1,1)
            }
            
            .ease-in-out {
                transition-timing-function: cubic-bezier(.4,0,.2,1)
            }
            
            .ease-out {
                transition-timing-function: cubic-bezier(0,0,.2,1)
            }
            
            .selected {
                background-color: #0c52a1;
                color: #fff;
                font-weight: 700
            }
            
            .highlight-code {
                color: #8b0000
            }
            
            .btn:hover i {
                color: #fff;
                transform: rotateY(360deg)
            }
            
            .banner {
                background-blend-mode: multiply;
                background-color: #bdbdbd;
                background-size: cover;
                background-repeat: no-repeat;
                background-position: center;
                margin-bottom: 1rem
            }
            
            .fixwhatsapp-btn {
                animation: blinking 2s ease-in-out infinite
            }
            
            .fixwhatsapp-btn i {
                color: #fff;
                font-size: 24px;
                animation: beating 2s ease-in-out infinite;
                text-decoration: none
            }
            
            @keyframes blinking {
                0% {
                    box-shadow: 0 0 #25d36680
                }
            
                70% {
                    box-shadow: 0 0 0 15px #25d36600
                }
            
                to {
                    box-shadow: 0 0 #0000
                }
            }
            
            @keyframes beating {
                0% {
                    transform: scale(1)
                }
            
                50% {
                    transform: scale(1.2)
                }
            
                to {
                    transform: scale(1)
                }
            }
            
            .logo-size img {
                height: 50px;
                width: 100px
            }
            
            .animated {
                animation: slide-top .5s cubic-bezier(.25,.46,.45,.94) both
            }
            
            @keyframes slide-top {
                0% {
                    transform: translateY(10px)
                }
            
                to {
                    transform: translateY(0)
                }
            }
            
            @media print {
                .non-printable {
                    display: none
                }
            
                .printable {
                    display: block;
                    left: -600px
                }
            }
            
            .sidebar-open {
                animation: opens .7s
            }
            
            @keyframes opens {
                0% {
                    transform: translate(100%);
                    animation-timing-function: cubic-bezier(.1,0,3,1)
                }
            
                to {
                    transform: translate(0);
                    animation-timing-function: cubic-bezier(0,0,.2,1)
                }
            }
            
            .loading-page {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255,255,255,.8);
                text-align: center;
                padding-top: 200px;
                font-size: 30px;
                font-family: sans-serif;
                z-index: 999
            }
            
            .spinner {
                margin: 0 auto;
                width: 17.6px;
                height: 17.6px;
                animation: spinner-o824ag 1.4s infinite linear
            }
            
            .spinner div {
                position: absolute;
                width: 100%;
                height: 100%;
                background: #0181dd;
                border-radius: 50%;
                animation: spinner-vse6n7 1.75s infinite ease
            }
            
            .spinner div:nth-child(1) {
                --rotation: 90
            }
            
            .spinner div:nth-child(2) {
                --rotation: 180
            }
            
            .spinner div:nth-child(3) {
                --rotation: 270
            }
            
            .spinner div:nth-child(4) {
                --rotation: 360
            }
            
            @keyframes spinner-vse6n7 {
                0%,to {
                    transform: rotate(calc(var(--rotation) * 1deg)) translateY(0)
                }
            
                50% {
                    transform: rotate(calc(var(--rotation) * 1deg)) translateY(300%)
                }
            }
            
            @keyframes spinner-o824ag {
                to {
                    transform: rotate(360deg)
                }
            }
            
            @media print {
                .printing {
                    width: auto;
                    overflow: auto;
                    font-size: 12px
                }
            }
            
            @media (min-width: 1024px) {
                .sidebar-open-off {
                    animation:none
                }
            }
            
            @media (max-width: 430px) {
                .frondEnd {
                    overflow-x:scroll
                }
            }
            
            figure {
                overflow-x: scroll
            }
            
            .table table {
                width: 100%;
                margin: 0 auto;
                border: 1px solid #cbc2c2;
                border-collapse: collapse;
                align-items: center
            }
            
            .table {
                display: block!important
            }
            
            .table thead {
                background: #0181dd;
                color: #fff;
                font-weight: 500
            }
            
            .table th,.table thead tr {
                text-align: center
            }
            
            .table thead tr th {
                border: 1px solid #cbc2c2;
                padding: 9px
            }
            
            .table tbody tr {
                text-align: center;
                font-size: 14px
            }
            
            .table tbody tr td {
                border: 1px solid #e6e6e6;
                padding: 9px
            }
            
            .table thead tr th img {
                background-color: #fff!important
            }
            
            .table h2 strong {
                text-align: center
            }
            
        </style>
    </head>
    <body>
        <p>{!! (!empty($body) ? $body : '') !!}</p>
    </body>
</html>