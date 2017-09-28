var eqApp = angular.module('equivalents', ['ngRoute']);
eqApp.config(function($routeProvider) {
    $routeProvider
        // route for the home page
        .when('/', {
            templateUrl : 'views/main.html',
            controller  : 'mainController'
        })
        .when('/report', {
            templateUrl : 'views/report.html',
            controller  : 'reportController'
        })
});