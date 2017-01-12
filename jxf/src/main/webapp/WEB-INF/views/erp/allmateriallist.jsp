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
		$("#allmaterial").addClass("current-menu-item"); //Add "active" class to selected tab  
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
			<div class="operation-bar">
				<a href="<c:url value="/material/creatematerial"/>" title="Register">
					<span class="glyphicon glyphicon-plus"></span>
				</a>
			</div>
			<div class="panel panel-default">
				<table
					class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><sp:message code="label.id" /></th>
							<th><sp:message code="label.materialid" /></th>
							<%-- <th><sp:message code="label.parentid" /></th> --%>
							<th><sp:message code="label.pinming" /></th>
							<th><sp:message code="label.thickness" /></th>
							<th><sp:message code="label.color" /></th>
							<th><sp:message code="label.weight" /></th>
							<th><sp:message code="label.length" /></th>
							<th><sp:message code="label.count" /></th>
							<th><sp:message code="label.totalweight" /></th>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<%--@elvariable id="users" type="java.util.List"--%>
					<c:forEach var="material" items="${page.list}" varStatus="loop">
					<c:if test="${material.materialId!=''}">
						<tr>
							<td><c:out value="${loop.index + 1}" /></td>
							<td><c:out value="${material.materialId}" /></td>
							<%-- <td><c:out value="${material.parent.materialId}" /></td> --%>
							<td><c:out value="${material.pinming}" /></td>
							<td><c:out value="${material.thickness}" /></td>
							<td><c:out value="${material.color}" /></td>
							<td><c:out value="${material.weight}" /></td>
							<td><c:out value="${material.length}" /></td>
							<c:if test="${material.riskflag == '1'}">
							<td style='width: 130px; padding: 4px; color:red'><c:out value="${material.count}" /></td>
							</c:if>
							<c:if test="${material.riskflag != '1'}">
							<td style='width: 130px; padding: 4px;'><c:out value="${material.count}" /></td>
							</c:if>
							<td><c:out value="${material.totalWeight}" /></td>
							<td><a
								href="<c:url value="/material/editmaterial?id=${material.id}"/>">
									<span class="glyphicon glyphicon-edit"></span>
							</a></td>
							<td><a
								href="javascript:if(confirm('确实要删除吗?'))location='<c:url value="/material/deletematerial?id=${material.id}"/>'">
									<span class="glyphicon glyphicon-trash"></span>
							</a></td>
						</tr>
						</c:if>
					</c:forEach>
				</table>
				<d:pagination page="${page.pageIndex}" total="${page.totalPage}"
					uri="/material/allmateriallist" />
			</div>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
