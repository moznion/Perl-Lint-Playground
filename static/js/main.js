if (typeof(window.console) === "undefined") { console = {}; console.log = console.warn = console.error = function(a) {}; }

Vue.filter('expl', function (expl) {
    if (Array.isArray(expl)) {
        expl = "PBP: " + expl.join(", ");
    }

    return expl;
});

$(function () {
    var violations;
    var apiServerURL = "http://perl-lint.moznion.net/api";

    var parseParam = function (url) {
        if (typeof url !== "string") {
            return {};
        }

        var fullParamString = url.split("?")[1];
        if (typeof fullParamString === "undefined") {
            return {};
        }

        var paramsStrings = fullParamString.split("&");
        var params = {};
        $.each(paramsStrings, function(i, param) {
            var pair = param.split("=");
            params[pair[0]] = pair[1];
        });
        return params;
    };

    var codeArea = $("#code");

    var model = new Vue({
        el: '#perl-lint',
        data: {
            violations: violations,
            showViolations: true,
        },
        methods: {
            lint: function (self) {
                if (!self) {
                    self = this;
                }

                var data = self.$data;

                var dfd = $.Deferred();
                dfd.done(function(res) {
                    data.showViolations = true;
                    data.violations = res;
                }).fail(function(res, status) {
                    data.showViolations = false;
                    data.error = status;
                });

                $.ajax({
                    type: "POST",
                    url: apiServerURL + "/lint",
                    data: {
                        src: codeArea.val()
                    },
                    success: dfd.resolve,
                    error: dfd.reject
                });

                return dfd.promise();
            },
            share: function () {
                var data = this.$data;

                var dfd = $.Deferred();
                dfd.done(function(res) {
                    data.showViolations = true;
                    location.href = "?id=" + res.id;
                }).fail(function(res) {
                    data.showViolations = false;
                    data.error = res.error;
                });

                $.ajax({
                    type: "POST",
                    url: apiServerURL + "/share",
                    data: {
                        src: codeArea.val()
                    },
                    success: dfd.resolve,
                    error: dfd.reject
                });

                return dfd.promise();
            },
            getSrc: function () {
                var self = this;

                var defaultSrc = "use strict;\n" +
                                 "use warnings;\n" +
                                 "\n" +
                                 "print \"Hello, world!!\";\n" +
                                 "\n" +
                                 "eval 'I am evil!';\n";

                var dfd = $.Deferred();
                dfd.done(function(res) {
                    if (res.src !== null) {
                        codeArea.val(res.src);
                        self.lint(self); // pre-lint
                        return;
                    }

                    codeArea.val(defaultSrc);
                }).fail(function(res) {
                    var statusCode = res.status;

                    if (statusCode === 404) {
                        codeArea.val(statusCode + " " + res.statusText + " (perhaps you mistake the URL?)");
                        return;
                    }

                    codeArea.val(defaultSrc);
                });

                var params = parseParam(location.href);

                $.ajax({
                    type: "GET",
                    url: apiServerURL + "/src",
                    data: {
                        id: params.id
                    },
                    success: dfd.resolve,
                    error: dfd.reject
                });

                return dfd.promise();
            }
        }
    });

    model.getSrc();
});

