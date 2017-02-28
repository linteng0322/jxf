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
	function searchcustomer() {
		var popup_width = 1024;
		var popup_height = 600;
		var popup_left = (screen.width - popup_width) / 2;
		var popup_top = (screen.height - popup_height) / 2;
		var popup_scrollbars = "no";

		var popup_property = "width=" + popup_width;
		var popup_property = popup_property + ",height=" + popup_height;
		var popup_property = popup_property + ",left=" + popup_left;
		var popup_property = popup_property + ",top=" + popup_top;
		var popup_property = popup_property + ",scrollbars=" + popup_scrollbars;

		window.open(
				'${pageContext.request.contextPath}/customer/searchcustomer',
				'customer', popup_property);
	}

	function searchsalesman() {
		var popup_width = 1024;
		var popup_height = 600;
		var popup_left = (screen.width - popup_width) / 2;
		var popup_top = (screen.height - popup_height) / 2;
		var popup_scrollbars = "no";

		var popup_property = "width=" + popup_width;
		var popup_property = popup_property + ",height=" + popup_height;
		var popup_property = popup_property + ",left=" + popup_left;
		var popup_property = popup_property + ",top=" + popup_top;
		var popup_property = popup_property + ",scrollbars=" + popup_scrollbars;

		window.open(
				'${pageContext.request.contextPath}/salesman/searchsalesman',
				'salesman', popup_property);
	}

	function clearall() {
		$("#orderId").val("");
		$("#customerIdentity").val("");
		$("#customerFamilyName").val(null);
		$("#salesmanid").val("");
		$("#salesmanname").val(null);
		$("#ispaid").val(null);
		$("#fromdate").val(null);
		$("#todate").val(null);
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
					<sp:message code="label.orderreport" />
				</div>
				<sf:form servletRelativeAction="searchmemojxforder" method="post"
					modelAttribute="jxforder" cssClass="form-horizontal">
					<sf:errors path="*" cssClass="alert alert-danger" element="div" />
					<div class="form-group">
						<sf:label path="orderId" cssClass="col-sm-3 control-label">
							<sp:message code="label.order" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="orderId" path="orderId" maxlength="20"
								cssClass="form-control" />
						</div>
						<%-- <sf:label path="jxforderstatus" cssClass="col-sm-3 control-label">
						<sp:message code="label.status" />
					</sf:label>
					<div class="col-sm-2">
						<sf:select id="jxforderstatus" path="jxforderstatus"
							maxlength="20" cssClass="form-control">
							<sf:option value="" label="全部"/>
							<sf:option value="allset" label="已匹配"/>
							<sf:option value="completed" label="已完成"/>
							<sf:option value="draft" label="草稿"/>
						</sf:select>
					</div> --%>
					</div>
					<div class="form-group">
						<sf:label path="customer" cssClass="col-sm-3 control-label">
							<sp:message code="label.customer" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="customerIdentity" type="hidden" path="customer.id"
								maxlength="20" cssClass="form-control" />
							<sf:input id="customerFamilyName" path="customer.name"
								onclick="searchcustomer()" onkeydown="searchcustomer()"
								maxlength="20" cssClass="form-control" />
						</div>
						<sf:label path="salesman" cssClass="col-sm-3 control-label">
							<sp:message code="label.salesman" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input id="salesmanid" type="hidden" path="salesman.id"
								maxlength="20" cssClass="form-control" />
							<sf:input id="salesmanname" path="salesman.name"
								onclick="searchsalesman()" onkeydown="searchsalesman()"
								maxlength="20" cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">

						<sf:label path="fromdate" cssClass="col-sm-3 control-label">
						从
					</sf:label>
						<div class="col-sm-3">
							<sf:input id="fromdate" path="fromdate" type="date"
								maxlength="20" cssClass="form-control" />
						</div>

						<sf:label path="todate" cssClass="col-sm-2 control-label">
						到
					</sf:label>
						<div class="col-sm-3">
							<sf:input id="todate" path="todate" type="date" maxlength="20"
								cssClass="form-control" />
						</div>
					</div>
					<div class="form-group">
						<sf:label path="ispaid" cssClass="col-sm-3 control-label">
							付款
					</sf:label>
						<div class="col-sm-2">
							<sf:select id="ispaid" path="ispaid" maxlength="10"
								cssClass="form-control">
								<sf:option value="" label="全部" />
								<sf:option value="true" label="已付款" />
								<sf:option value="false" label="未付款" />
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
							<button type="button" onclick="clearall()"
								class="btn btn-primary">
								<sp:message code="label.clear" />
							</button>
						</div>
					</div>
				</sf:form>
			</div>
			<div class="operation-bar">
				<a href="<c:url value="/memojxforder/out"/>" title="Register"> <span
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
							<%-- <th><sp:message code="label.calweight" /></th> --%>
							<th><sp:message code="label.actweight" /></th>
							<th>总金额</th>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<%--@elvariable id="users" type="java.util.List"--%>
					<c:forEach var="jxforder" items="${list}" varStatus="loop">

						<tr>
							<td><c:out value="${loop.index + 1}" /></td>
							<td><a
								href="/jxf/memojxforder/matchmaterialformemojxforder?id=${jxforder.id}"><c:out
										value="${jxforder.orderId}" /></a></td>
							<td><c:out value="${jxforder.customer.name}" /></td>
							<td><c:out value="${jxforder.actweight}" /></td>
							<td><c:out value="${jxforder.totalincome}" /></td>
							<td><c:if
									test="${jxforder.jxforderstatus!='completed' && jxforder.jxforderstatus!='partial'}">
									<a
										href="<c:url value="/memojxforder/editmemojxforder?id=${jxforder.id}"/>">
										<span class="glyphicon glyphicon-edit"></span>
									</a>
								</c:if> <c:if
									test="${jxforder.jxforderstatus=='completed' || jxforder.jxforderstatus=='partial'}">
									<span class="glyphicon glyphicon-edit"></span>
								</c:if></td>
							<td><a
								href="javascript:if(confirm('确实要删除吗?'))location='<c:url value="/memojxforder/deletememojxforder?id=${jxforder.id}" />'">
									<span class="glyphicon glyphicon-trash"></span>
							</a></td>
						</tr>

					</c:forEach>
				</table>
			</div>
			<div class="form-group">
				<sf:label path="listactweight" cssClass="col-sm-3 control-label">
					<sp:message code="label.actweight" />
				</sf:label>
				<div class="col-sm-2">
					<sf:input id="listactweight" path="listactweight" readonly="true"
						value="${listactweight}" maxlength="20" cssClass="form-control" />
				</div>
				<sf:label path="listtotalincome" cssClass="col-sm-3 control-label">
					汇总金额
				</sf:label>
				<div class="col-sm-2">
					<sf:input id="listtotalincome" path="listtotalincome"
						readonly="true" value="${listtotalincome}" maxlength="20"
						cssClass="form-control" />
				</div>
			</div>
		</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
