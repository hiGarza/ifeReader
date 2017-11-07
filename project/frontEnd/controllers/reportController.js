eqApp.controller('reportController', function($rootScope, $scope, $http) {
	$scope.searchDate = "2017-09-28";
	$scope.getReport = function(){
		$http.get('https://mwalm5619b.execute-api.us-west-1.amazonaws.com/production/access?searchDate='+$scope.searchDate)
			.then(function(response){
				$scope.accessList = response.data.Items;
	        	console.log($scope.accessList);
	      	}, function(error){console.log(error)});
	};
});