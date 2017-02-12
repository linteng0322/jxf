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

			<sf:form servletRelativeAction="searchmaterial" method="post"
				modelAttribute="material" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />

				
				<div class="panel panel-default">
					<table
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>&nbsp;</th>
								<th><sp:message code="label.materialid" /></th>
								<th><sp:message code="label.thickness" /></th>
								<th><sp:message code="label.color" /></th>
								<th><sp:message code="label.length" /></th>
								<th><sp:message code="label.count" /></th>
								<th><sp:message code="label.riskcount" /></th>
								<th>&nbsp;</th>
							</tr>
						</thead>
						<c:forEach var="material" items="${materiallist}" varStatus="loop">
							<tr>
								<td><c:out value="${loop.index + 1}" /></td>
								<td><c:out value="${material.materialId}" /></td>
								<td><c:out value="${material.thickness}" /></td>
								<td><c:out value="${material.color}" /></td>
								<td><c:out value="${material.length}" /></td>
								<td style="color:red"><c:out value="${material.count}"></c:out></td>
								<td><c:out value="${material.riskcount}" /></td>
								<td><a
								href="<c:url value="/material/editriskmaterial?id=${material.id}"/>">
									<span class="glyphicon glyphicon-edit"></span>
							</a></td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</sf:form>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
