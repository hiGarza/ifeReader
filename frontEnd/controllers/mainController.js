eqApp.controller('mainController', function($rootScope, $scope, $http) {
	$scope.person = {image:"placeholder.jpg"};
    var evtSource = new EventSource("//127.0.0.1:8080");
    evtSource.onmessage = function(e) {
		$scope.person = JSON.parse(e.data);
		var date = "";
		$scope.person.date = new Date($scope.person.access);
		$scope.person.image = $scope.person.userID+".jpg"
		$scope.$apply();
	}

	$scope.save = function(){
		if($scope.person.userID !== undefined){
			$http.post('https://mwalm5619b.execute-api.us-west-1.amazonaws.com/production/access', $scope.person)
			.then(function(response){
	        	console.log(response);
	        	$scope.person = {image:"placeholder.jpg"};
	      	}, function(error){console.log(error)});
		}
	};
});