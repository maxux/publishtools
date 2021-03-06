module publisher
import os
fn template_wiki_root(reponame string, repourl string) string {

    index_wiki := r'
    <!DOCTYPE html>
    <html>
    <head>
        <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-100065546-4"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag("js", new Date());

            gtag("config", "UA-100065546-4");
        </script>
        <script type="text/javascript" src="https://www.freeprivacypolicy.com/public/cookie-consent/3.1.0/cookie-consent.js"></script> <script type="text/javascript"> document.addEventListener("DOMContentLoaded", function () { cookieconsent.run({"notice_banner_type":"headline","consent_type":"express","palette":"light","language":"en","website_name":"https://wiki.threefold.io/","cookies_policy_url":"https://wiki.threefold.io/#/privacypolicy"}); }); </script> <script type="text/plain" cookie-consent="tracking" async src="https://www.googletagmanager.com/gtag/js?id=UA-100065546-4"></script> <script type="text/plain" cookie-consent="tracking"> window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);} gtag("js", new Date()); gtag("config", "UA-100065546-4"); </script> <script type="text/plain" cookie-consent="functionality">window.$crisp=[];window.CRISP_WEBSITE_ID="1a5a5241-91cb-4a41-8323-5ba5ec574da0";(function(){d=document;s=d.createElement("script");s.src="https://client.crisp.chat/l.js";s.async=1;d.getElementsByTagName("head")[0].appendChild(s);})();</script>    
      <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <meta charset="UTF-8">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/docsify-themeable@0/dist/css/theme-simple.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/simplelightbox/2.1.5/simple-lightbox.min.css">

    <style>
        .markdown-section {
            max-width: 60em !important;  
            padding-left: 0 !important;
            padding-right: 0 !important;
        }
        .gallery {
            display: flex;
            flex-wrap: wrap;
        }
        .gallery > a {
            flex: 0 0 33.333334%;
            max-width: 33.333334%;
            overflow: hidden;
        }
        .gallery > a:hover > img {
            transform: scale(1.2);
        }
        .gallery > a > img {
            height: 100%;
            width: 100%;
            transition: transform 0.3s ease-in;
        }
    </style>
    </head>
    <body>
      <div id="app"></div>
      <script>
        window.$docsify = {
            name: "@reponame",
            repo: "@repourl",
            loadSidebar: true,
            loadNavbar: true,
            auto2top: true,
            search: "auto",
            remoteMarkdown: {
              tag: "remoteMarkdownUrl",
            },
            subMaxLevel: 0,
            themeable: {
                readyTransition : true, // default
                responsiveTables: true  // default
            },
            markdown: {
                renderer: {
                    code: function (code, lang) {
                        if (lang === "pdf") {
                            return `<embed src="https://drive.google.com/viewerng/viewer?embedded=true&url="` + code +  `width="100%" height="800">`
                        }
                        if (lang === "gallery") {
                            let lines = code.split("\\n");
                            let images = "";
                            for (let line of lines) {
                                if (line) {
                                    let parts = line.split("=");
                                    if (parts.length == 2){
                                        let name = parts[0].trim();
                                        let url = parts[1].trim()
                                        images += `<a href=${url} class="big">
                                                    <img src=${url} alt="${name}" title="${name}">
                                                    </a>`;

                                    }
                                }
                            }
                            return (`<div class="gallery" style="position: initial;">${images}</div>`);
                        }
                        return this.origin.code.apply(this, arguments);
                    }
                }
            },
            // complete configuration parameters
            search: {
                maxAge: 86400000, // Expiration time, the default one day
                paths: "auto",
                placeholder: "Type to search",
                noData: "No Results!",
                depth: 6,
                hideOtherSidebarContent: false, // whether or not to hide other sidebar content
            },
            plugins: [
                function (hook) {
                    hook.doneEach(() => {
                        // gallery
                        // do not init gallery if not loaded into dom
                        if (!document.querySelector(".gallery")) {
                            return;
                        }
                        new SimpleLightbox(".gallery a");
                    });
                },
            ]
        }
      </script>
      <script src="//cdn.jsdelivr.net/npm/docsify/lib/docsify.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/docsify-example-panels"></script>
      <script src="//cdn.jsdelivr.net/npm/prismjs/components/prism-bash.min.js"></script>
      <script src="//cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
      <script src="//unpkg.com/docsify/lib/plugins/search.min.js"></script>
      <script src="//unpkg.com/docsify-remote-markdown/dist/docsify-remote-markdown.min.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/docsify-tabs@1"></script>
      <script src="https://cdn.jsdelivr.net/npm/docsify-themeable@0"></script>
      <script src="//unpkg.com/docsify-sidebar-collapse/dist/docsify-sidebar-collapse.min.js"></script>
      <script src="//cdn.jsdelivr.net/npm/docsify/lib/plugins/zoom-image.min.js"></script>
      <script src="//cdn.jsdelivr.net/npm/docsify-copy-code"></script>
      <script src="//unpkg.com/docsify-glossary/dist/docsify-glossary.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/simplelightbox/2.1.5/simple-lightbox.min.js"></script>
    </body>
    </html>
    '


    mut out := index_wiki
    out = out.replace("@reponame",reponame)
    out = out.replace("@repourl",repourl)
    return out
}

fn template_wiki_root_save(destdir string, reponame string, repourl string){
    out := template_wiki_root(reponame, repourl)
    os.write_file("$destdir/index.html",out) or {panic(err)}
}

