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
		$("#alltransaction").addClass("current-menu-item"); //Add "active" class to selected tab  
	});

	function searchmaterial() {
		var popup_width = 1024;
		var popup_height = 600;
		var popup_left = (screen.width - popup_width) / 2;
		var popup_top = (screen.height - popup_height) / 2;
		var popup_scrollbars = "yes";

		var popup_property = "width=" + popup_width;
		var popup_property = popup_property + ",height=" + popup_height;
		var popup_property = popup_property + ",left=" + popup_left;
		var popup_property = popup_property + ",top=" + popup_top;
		var popup_property = popup_property + ",scrollbars=" + popup_scrollbars;

		window.open(
				'${pageContext.request.contextPath}/material/searchmaterial',
				'material', popup_property);
	}
	function clearall() {
		$("#orderNo").val("");
		$("#materialIdentity").val("");
		$("#materialIdString").val("");
		$("orderNo").val("");
		$("#type").val("");
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
						<sp:message code="label.transactionsearch" />
					</div>
			<sf:form servletRelativeAction="searchtransaction" method="post"
				modelAttribute="transaction" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />

				<div class="form-group">
					<div class="col-sm-3">
						<sf:hidden id="materialIdentity" path="material.id"
							onclick="searchmaterial()" maxlength="20" cssClass="form-control" />
					</div>
				</div>
				<div class="form-group">
					<sf:label path="orderNo" cssClass="col-sm-3 control-label">
						<sp:message code="label.order" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input id="orderNo" path="orderNo" maxlength="20"
							cssClass="form-control" />
					</div>
				
					<sf:label path="material.id" cssClass="col-sm-3 control-label">
						<sp:message code="label.materialid" />
					</sf:label>
					<div class="col-sm-3">
						<sf:input id="materialIdString" path="material.materialId"
							onclick="searchmaterial()" maxlength="20" cssClass="form-control" />
					</div>
					<sf:label path="type" cssClass="col-sm-3 control-label">
						<sp:message code="label.transactiontype" />
					</sf:label>
					<div class="col-sm-3">
						<sf:select id="type" path="type" maxlength="20"
							cssClass="form-control">
							<sf:option value="" label="全部"/>
							<sf:option value="IN" label="入库"/>
							<sf:option value="OUT" label="出库"/>
						</sf:select>
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
				</div>
			</sf:form>
			</div>
			<div class="panel panel-default">
				<table
					class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><sp:message code="label.id" /></th>
							<th><sp:message code="label.order" /></th>
							<th><sp:message code="label.materialid" /></th>
							<th><sp:message code="label.transactiontype" /></th>
							<th><sp:message code="label.client" /></th>
							<th><sp:message code="label.pinming" /></th>
							<th><sp:message code="label.thickness" /></th>
							<th><sp:message code="label.color" /></th>
							<th><sp:message code="label.weight" /></th>
							<th><sp:message code="label.length" /></th>
							<th><sp:message code="label.count" /></th>
							<th><sp:message code="label.totalweight" /></th>
							<th><sp:message code="label.creationdate" /></th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<%--@elvariable id="users" type="java.util.List"--%>
					<c:forEach var="transaction" items="${page.list}" varStatus="loop">
						<tr>
							<td><c:out value="${loop.index + 1}" /></td>
							<td><c:out value="${transaction.orderNo}" /></td>
							<td><c:out value="${transaction.material.materialId}" /></td>
							<td><c:out value="${transaction.type}" /></td>
							<td><c:out value="${transaction.customer.name}" /></td>
							<td><c:out value="${transaction.material.pinming}" /></td>
							<td><c:out value="${transaction.material.thickness}" /></td>
							<td><c:out value="${transaction.material.color}" /></td>
							<td><c:out value="${transaction.material.weight}" /></td>
							<td><c:out value="${transaction.material.length}" /></td>
							<td><c:out value="${transaction.count}" /></td>
							<td><c:out value="${transaction.totalWeight}" /></td>
							<td><c:out value="${transaction.createdOn}" /></td>
						</tr>
					</c:forEach>
				</table>
				<d:pagination page="${page.pageIndex}" total="${page.totalPage}"
					uri="/transaction/alltransactionlist" />
			</div>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
