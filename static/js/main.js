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

    var model = new Vue({
        el: '#perl-lint',
        data: {
            violations: violations,
            showViolations: true,
        },
        methods: {
            submit: function () {
                var data = this.$data;

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
                        src: $("#code").val()
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
                        src: $("#code").val()
                    },
                    success: dfd.resolve,
                    error: dfd.reject
                });

                return dfd.promise();
            }
        }
    });

    if ($("#code").val() === '') {
        $("#code").val(
            "use strict;\n" +
            "use warnings;\n" +
            "\n" +
            "print \"Hello, world!!\";\n" +
            "\n" +
            "eval 'I am evil!';\n"
        );
    }
});

