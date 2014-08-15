if (typeof(window.console) === "undefined") { console = {}; console.log = console.warn = console.error = function(a) {}; }

Vue.filter('expl', function (expl) {
    if (Array.isArray(expl)) {
        expl = "PBP: " + expl.join(", ");
    }

    return expl;
})

$(function () {
    var violations;
    var apiServerURL = "http://localhost:5000/api";

    var model = new Vue({
        el: '#perl-lint',
        data: {
            violations: violations,
            showViolations: true
        },
        methods: {
            onClick: function (e) {
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
            }
        }
    });
});

