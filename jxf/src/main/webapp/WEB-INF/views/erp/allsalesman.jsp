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
			<div class="panel panel-default">
				<div class="panel-heading">
					<sp:message code="label.salesman" />
				</div>
			</div>
			<div class="operation-bar">
				<a href="<c:url value="/salesman/createsalesman"/>" title="Register">
					<span class="glyphicon glyphicon-plus"></span>
				</a>
			</div>
			<div class="panel panel-default">
				<table
					class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><sp:message code="label.id" /></th>
							<th><sp:message code="label.name" /></th>
							<th><sp:message code="label.phone" /></th>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<%--@elvariable id="users" type="java.util.List"--%>
					<c:forEach var="salesman" items="${page.list}" varStatus="loop">
						<tr>
							<td><c:out value="${loop.index + 1}" /></td>
							<td><c:out value="${salesman.name}" /></td>
							<td><c:out value="${salesman.phone}" /></td>
							<td><a
								href="<c:url value="/salesman/editsalesman?id=${salesman.id}"/>">
									<span class="glyphicon glyphicon-edit"></span>
							</a></td>
							<td><a
								href="javascript:if(confirm('确实要删除吗?'))location='<c:url value="/salesman/deletesalesman?id=${salesman.id}"/>'">
									<span class="glyphicon glyphicon-trash"></span>
							</a></td>
						</tr>
					</c:forEach>
				</table>
				<d:pagination page="${page.pageIndex}" total="${page.totalPage}"
					uri="/salesman/allsalesman" />
			</div>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
