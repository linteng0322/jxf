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
	function del_sure() {
		var gnl = confirm("你真的确定要删除吗?");
		if (gnl == true) {
			return true;
		} else {
			return false;
		}
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
			<div class="operation-bar">
				<a href="<c:url value="/jxforder/out"/>" title="Register"> <span
					class="glyphicon glyphicon-plus"></span>
				</a>
			</div>
			<div class="panel panel-default">
				<table
					class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><sp:message code="label.id" /></th>
							<th><sp:message code="label.order" /></th>
							<th><sp:message code="label.client" /></th>
							<th><sp:message code="label.status" /></th>
							<th><sp:message code="label.calweight" /></th>
							<th><sp:message code="label.actweight" /></th>
							<th>总金额</th>
							<th><sp:message code="label.payment" /></th>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
							<!-- <th>&nbsp;</th> -->
						</tr>
					</thead>
					<%--@elvariable id="users" type="java.util.List"--%>
					<c:forEach var="jxforder" items="${page.list}" varStatus="loop">

						<tr>
							<td><c:out value="${loop.index + 1}" /></td>
							<td><a
								href="<c:url value="/jxforder/matchmaterialforjxforder?id=${jxforder.id}"/>">
									<c:out value="${jxforder.orderId}" />
							</a></td>
							<%-- <td><c:out value="${material.parent.materialId}" /></td> --%>
							<td><c:out value="${jxforder.customer.name}" /></td>
							<td><c:out value="${jxforder.jxforderstatus=='completed'?'出库完成':'需出库'}" /></td>
							<td><c:out value="${jxforder.calweight}" /></td>
							<td><c:out value="${jxforder.actweight}" /></td>
							<td><c:out value="${jxforder.totalincome}" /></td>
							<c:if test="${jxforder.ispaid==true}">
								<td><sp:message code="label.payment" /></td>
							</c:if>
							<c:if test="${jxforder.ispaid!=true}">
								<td><a
									href="<c:url value="/jxforder/matchmaterialforjxforder?id=${jxforder.id}"/>"
									style='color: red'> <sp:message code="label.notpaid" /></a></td>
							</c:if>
							<td><c:if test="${jxforder.jxforderstatus!='completed' && jxforder.jxforderstatus!='partial'}">
									<a
										href="<c:url value="/jxforder/editjxforder?id=${jxforder.id}"/>">
										<span class="glyphicon glyphicon-edit"></span>
									</a>
								</c:if>
								<c:if test="${jxforder.jxforderstatus=='completed' || jxforder.jxforderstatus=='partial'}">
									<span class="glyphicon glyphicon-edit"></span>
								</c:if>
								</td>
							<td><a
								href="javascript:if(confirm('确实要删除吗?'))location='<c:url value="/jxforder/deletejxforder?id=${jxforder.id}" />'">
									<span class="glyphicon glyphicon-trash"></span>
							</a></td>
							<%-- <td><a
								href="<c:url value="/jxforder/matchmaterialforjxforder?id=${jxforder.id}"/>">
									<sp:message code="label.transactionsout" />
							</a></td> --%>
						</tr>

					</c:forEach>
				</table>
				<d:pagination page="${page.pageIndex}" total="${page.totalPage}"
					uri="/jxforder/alljxforder" />
			</div>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
