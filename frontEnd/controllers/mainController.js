eqApp.controller('mainController', function($rootScope, $scope, $http) {
	$scope.person = {image:"placeholder.jpg"};
    var evtSource = new EventSource("//127.0.0.1:8080");
    evtSource.onmessage = function(e) {
		$scope.person = JSON.parse(e.data);
		var date = "";
		$scope.person.date = new Date($scope.person.access);
		console.log($scope.person.date);
		console.log(typeof $scope.person.date);
		$scope.person.image = "temp.jpg"
		$scope.person.exit = false;
		$scope.$apply();
	}
});