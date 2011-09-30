(function () {
    var output, Converter;
    if (typeof exports === "object" && typeof require === "function") { // we're in a CommonJS (e.g. Node.js) module
        output = exports;
        Converter = require("./Markdown.Converter").Converter;
    } else {
        output = window.Markdown;
        Converter = output.Converter;
    }
        
    output.getSanitizingConverter = function () {
        var converter = new Converter();
        converter.hooks.chain("postConversion", sanitizeHtml);
        converter.hooks.chain("postConversion", balanceTags);
        return converter;
    }

    function sanitizeHtml(html) {
        return html.replace(/<[^>]*>?/gi, sanitizeTag);
    }

    // (tags that can be opened/closed) | (tags that stand alone)
    var basic_tag_whitelist = /^(<\/?(a|abbr|b|bdo|blockquote|br|caption|cite|code|col|colgroup|dd|del|details|dfn|dl|dt|em|figcaption|figure|h2|h3|i|ins|kbd|li|mark|ol|p|pre|q|rp|rt|s|samp|strong|sup|sub|table|tbody|td|tfoot|th|thead|time|tr|ul|var|wbr)>|<(br|hr)\s?\/?>)$/i;
    
    // <a href="url..." optional title optional lang>|</a>
    var a_white = /^(<a\shref="((mailto|https?|ftp):\/\/|\/)[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)]+"(\stitle="[^"<>]+")?(\slang="[^"<>]+")?\s?>|<\/a>)$/i;
    
    var blockquote_white = /^(<blockquote\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var col_white = /^(<col\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var colgroup_white = /^(<colgroup\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var del_white = /^(<del\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    // <img src="url..." optional width  optional height  optional alt  optional title optional lang
    var img_white = /^(<img\ssrc="(https?:\/\/|\/)[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)]+"(\swidth="\d{1,3}")?(\sheight="\d{1,3}")?(\salt="[^"<>]*")?(\stitle="[^"<>]*")?(\slang="[^"<>]+")?\s?\/?>)$/i;
    
    var ins_white = /^(<ins\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var ol_white = /^(<ol\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var q_white = /^(<q\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var table_white = /^(<table\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var td_white = /^(<td\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var th_white = /^(<th\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var time_white = /^(<time\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;
    
    var ul_white = /^(<ul\s?[-A-Za-z0-9+&@#\/%?=~_|!:,.;\(\)\"]*>)$/i;

    function sanitizeTag(tag) {
        if (tag.match(basic_tag_whitelist) || tag.match(a_white) || tag.match(blockquote_white) || tag.match(colgroup_white) || tag.match(del_white) || tag.match(img_white) || tag.match(ins_white) || tag.match(ol_white) || tag.match(q_white) || tag.match(table_white) || tag.match(td_white) || tag.match(th_white) || tag.match(time_white) || tag.match(ul_white))
            return tag;
        else
            return "";
    }

    /// <summary>
    /// attempt to balance HTML tags in the html string
    /// by removing any unmatched opening or closing tags
    /// IMPORTANT: we *assume* HTML has *already* been 
    /// sanitized and is safe/sane before balancing!
    /// 
    /// adapted from CODESNIPPET: A8591DBA-D1D3-11DE-947C-BA5556D89593
    /// </summary>
    function balanceTags(html) {

        if (html == "")
            return "";

        var re = /<\/?\w+[^>]*(\s|$|>)/g;
        // convert everything to lower case; this makes
        // our case insensitive comparisons easier
        var tags = html.toLowerCase().match(re);

        // no HTML tags present? nothing to do; exit now
        var tagcount = (tags || []).length;
        if (tagcount == 0)
            return html;

        var tagname, tag;
        var ignoredtags = "<p><img><br><li><hr>";
        var match;
        var tagpaired = [];
        var tagremove = [];
        var needsRemoval = false;

        // loop through matched tags in forward order
        for (var ctag = 0; ctag < tagcount; ctag++) {
            tagname = tags[ctag].replace(/<\/?(\w+).*/, "$1");
            // skip any already paired tags
            // and skip tags in our ignore list; assume they're self-closed
            if (tagpaired[ctag] || ignoredtags.search("<" + tagname + ">") > -1)
                continue;

            tag = tags[ctag];
            match = -1;

            if (!/^<\//.test(tag)) {
                // this is an opening tag
                // search forwards (next tags), look for closing tags
                for (var ntag = ctag + 1; ntag < tagcount; ntag++) {
                    if (!tagpaired[ntag] && tags[ntag] == "</" + tagname + ">") {
                        match = ntag;
                        break;
                    }
                }
            }

            if (match == -1)
                needsRemoval = tagremove[ctag] = true; // mark for removal
            else
                tagpaired[match] = true; // mark paired
        }

        if (!needsRemoval)
            return html;

        // delete all orphaned tags from the string

        var ctag = 0;
        html = html.replace(re, function (match) {
            var res = tagremove[ctag] ? "" : match;
            ctag++;
            return res;
        });
        return html;
    }
})();
