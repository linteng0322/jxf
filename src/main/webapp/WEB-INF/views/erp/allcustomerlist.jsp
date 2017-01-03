<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="f" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sp" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix='sec'
	uri='http://www.springframework.org/security/tags'%>
<%@ taglib prefix="d" uri="https://github.com/xpjsky/devices/tags"%>
<html>
<head>

<title>JXF</title>

<%@ include file="../includes/jsheader.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		$("#allcustomer").addClass("current-menu-item"); //Add "active" class to selected tab  
	});
</script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body class="home">
	<div id="page">
		<%@ include file="../includes/header.jsp"%>
		<div id="csidebar" style="float: left; width: 20%;">
			<%@ include file="../includes/csidebar.jsp"%>
		</div>

		<div style="float: right; width: 80%;">

			<sf:form servletRelativeAction="searchcustomerlist" method="post"
				modelAttribute="customer" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />

				<%-- <div class="form-group">
					<sf:label path="name" cssClass="col-sm-3 control-label">
						<sp:message code="label.client" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="name" maxlength="20" cssClass="form-control" />
					</div>
					<div class="col-sm-2">
						<button type="submit" class="btn btn-primary">
							<sp:message code="label.search" />
						</button>
					</div>
				</div> --%>
			</sf:form>

			<div class="operation-bar">
				<a href="<c:url value="/customer/createcustomer"/>" title="Register">
					<span class="glyphicon glyphicon-plus"></span>
				</a>
			</div>
			<div class="panel panel-default">
				<table
					class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><sp:message code="label.id" /></th>
							<th><sp:message code="label.client" /></th>
							<%-- <th><sp:message code="label.phone" /></th>
							<th><sp:message code="label.address" /></th> --%>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<%--@elvariable id="users" type="java.util.List"--%>
					<c:forEach var="customer" items="${page.list}" varStatus="loop">
						<tr>
							<td><c:out value="${loop.index + 1}" /></td>
							<td><c:out value="${customer.name}" /></td>
							<%-- 
							<td><c:out value="${customer.phone}" /></td>
							<td><c:out value="${customer.address}" /></td> --%>

							<td><a
								href="<c:url value="/customer/editcustomer?id=${customer.id}"/>">
									<span class="glyphicon glyphicon-edit"></span>
							</a></td>
							<td><a
								href="<c:url value="/customer/deletecustomer?id=${customer.id}"/>">
									<span class="glyphicon glyphicon-trash"></span>
							</a></td>
						</tr>
					</c:forEach>
				</table>
				<d:pagination page="${page.pageIndex}" total="${page.totalPage}"
					uri="/customer/allcustomerlist" />
			</div>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
