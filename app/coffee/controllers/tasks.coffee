# Copyright 2013 Andrey Antukh <niwi@niwi.be>
#
# Licensed under the Apache License, Version 2.0 (the "License")
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


TasksViewController = ($scope, $location, $rootScope, $routeParams, $q, rs, $data) ->
    $rootScope.pageSection = 'tasks'
    $rootScope.pageBreadcrumb = ["", "Tasks", ""]
    $rootScope.projectId = parseInt($routeParams.pid, 10)

    projectId = $rootScope.projectId
    taskId = $routeParams.taskid

    $scope.task = {}
    $scope.form = {}
    $scope.updateFormOpened = false

    loadAttachments = ->
        $scope.attachment = undefined
        rs.getTaskAttachments(projectId, taskId).then (attachments) ->
            $scope.attachments = attachments

    loadTask = ->
        rs.getTask(projectId, taskId).then (task) ->
            $scope.task = task
            $scope.form = _.extend({}, $scope.task._attrs)

            breadcrumb = _.clone($rootScope.pageBreadcrumb)
            breadcrumb[2] = "##{task.ref}"

            $rootScope.pageBreadcrumb = breadcrumb

    # Load initial data
    $data.loadProject($scope).then ->
        $data.loadUsersAndRoles($scope).then ->
            loadAttachments()
            loadTask()

    $scope.isSameAs = (property, id) ->
        return ($scope.task[property] == parseInt(id, 10))

    $scope.submit = ->
        for key, value of $scope.form
            $scope.task[key] = value

        $scope.task.save().then (task) ->
            rs.uploadTaskAttachment(projectId, taskId, $scope.attachment).then () ->
                loadTask()
                loadAttachments()

    $scope.removeAttachment = (attachment) ->
        $scope.attachments = _.reject($scope.attachments, {"id": attachment.id})
        attachment.remove()

    $scope.removeTask = (task) ->
        milestone = task.milestone
        task.remove().then ->
            $location.url("/project/#{projectId}/dashboard/#{milestone}/")


module = angular.module("greenmine.controllers.tasks", [])
module.controller("TasksViewController", ['$scope', '$location', '$rootScope', '$routeParams', '$q', 'resource', "$data", TasksViewController])
