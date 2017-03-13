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

	function formatCurrency(num) {
		num = num.toString().replace(/\$|\,/g, '');
		if (isNaN(num))
			num = "0";
		sign = (num == (num = Math.abs(num)));
		num = Math.floor(num * 100 + 0.50000000001);
		cents = num % 100;
		num = Math.floor(num / 100).toString();
		if (cents < 10)
			cents = "0" + cents;
		for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
			num = num.substring(0, num.length - (4 * i + 3)) + ','
					+ num.substring(num.length - (4 * i + 3));
		return (((sign) ? '' : '-') + num + '.' + cents);
	}

	function jxfconfirm(str) {
		if (confirm(str)) {

			return true;
		} else
			return false;
	}
	function clearall() {
		$("#materialId").val("");
	}
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
					<sp:message code="label.materialmaintain" />
				</div>
			</div>
			<sf:form servletRelativeAction="allmateriallist" method="post"
				modelAttribute="material" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				
				
				<%-- <div class="form-group">
					<sf:label path="materialId" cssClass="col-sm-3 control-label">
						<sp:message code="label.materialid" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input id="materialId" path="materialId" maxlength="20"
							cssClass="form-control" />
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-offset-3 col-sm-1">
						<button type="submit" class="btn btn-primary">
							<sp:message code="label.search" />
						</button>
					</div>
					<div class="col-sm-offset-3 col-sm-1">
						<button type="button" onclick="clearall()" class="btn btn-primary">
							<sp:message code="label.clear" />
						</button>
					</div>
				</div> --%>
				
				<div class="operation-bar">
					<a href="<c:url value="/material/creatematerial"/>"
						title="Register"> <span class="glyphicon glyphicon-plus"></span>
					</a>
				</div>
				<div class="panel panel-default">
					<table
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th><sp:message code="label.id" /></th>
								<th><sp:message code="label.materialid" /></th>
								<th><sp:message code="label.thickness" /></th>
								<th><sp:message code="label.color" /></th>
								<th><sp:message code="label.length" /></th>
								<th><sp:message code="label.weight" /></th>
								<th><sp:message code="label.pinming" /></th>
								<th><sp:message code="label.count" /></th>
								<th><sp:message code="label.totalweight" /></th>
								<th>&nbsp;</th>
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
									<td><c:out value="${material.thickness}" /></td>
									<td><c:out value="${material.color}" /></td>
									<td><c:out value="${material.length}" /></td>
									<td><c:out value="${material.weight}" /></td>
									<td><c:out value="${material.pinming}" /></td>
									<c:if test="${material.riskflag == '1'}">
										<td style='width: 130px; padding: 4px; color: red'><c:out
												value="${material.count}" /></td>
									</c:if>
									<c:if test="${material.riskflag != '1'}">
										<td style='width: 130px; padding: 4px;'><c:out
												value="${material.count}" /></td>
									</c:if>
									<td><c:out value="${material.totalWeight}" /></td>
									<td><a
										href="<c:url value="/material/editmaterial?id=${material.id}"/>">
											<span class="glyphicon glyphicon-edit"></span>
									</a></td>
									<td><a
										href="<c:url value="/material/copymaterial?id=${material.id}"/>">
											<span class="glyphicon glyphicon-tint"></span>
									</a></td>
									<td><a
										href="javascript:if(jxfconfirm('确实要删除吗?'))location='<c:url value="/material/deletematerial?id=${material.id}"/>'">
											<span class="glyphicon glyphicon-trash"></span>
									</a></td>
								</tr>
							</c:if>
						</c:forEach>
					</table>
					<d:pagination page="${page.pageIndex}" total="${page.totalPage}"
						uri="/material/allmateriallist" />
				</div>
			</sf:form>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
