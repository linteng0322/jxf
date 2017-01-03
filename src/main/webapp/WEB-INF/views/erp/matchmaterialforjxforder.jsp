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
		$("#allmaterialgroup").addClass("current-menu-item"); //Add "active" class to selected tab  
	});

	function submitmatch() {
		var appendstring;
		var x = document.getElementsByName("sequence");
		var i = x.length;
		var materialorderstring;
		var flag = "";
		for (var j = 1; j <= i; j++) {
			var elementid = "sequence" + j;
			searchmaterial = "searchmaterial" + j;//materialorder identity
			var searchmaterial = $('input:hidden[id="' + elementid + '"]')
					.val();
			elementid = "materialtype" + j;
			var materialtype = $('input:hidden[id="' + elementid + '"]').val();
			if (materialId != "") {
				if (flag == "") {
					appendstring = searchmaterial + ";" + materialtype;
					flag = "has";
				} else {
					appendstring = appendstring + "," + searchmaterial + ";"
							+ materialtype;
				}
			}
			/* $('#materialchildrenstring', document)
			.append(materialId);
			alert($('#materialchildrenstring')); */
		}
		$('#matchmaterial').val(appendstring);
	}

	function check() {
		if (confirm('确实要出库吗?')) {
			var x = document.getElementsByName("materialcount");
			var l = x.length;
			for (var j = 1; j <= l; j++) {
				var materialcount = $('input:text[id="materialcount' + j + '"]')
						.val();
				if (materialcount == "") {
					alert("请编辑此订单，为第" + j + "行物料添加数量。");
					return false;
				}
			}

			x = document.getElementsByName("searchmaterial");
			l = x.length;
			for (var j = 1; j <= l; j++) {
				var searchmaterial = $(
						'input:hidden[id="searchmaterial' + j + '"]').val();
				if (searchmaterial == "") {
					alert("请编辑此订单，匹配第" + j + "行。");
					return false;
				}
			}
		}
		$
				.ajax({
					type : "POST",
					dataType : "text",
					url : "${pageContext.request.contextPath}/jxforder/checkallenoughstock?identity=${order.id}",
					//data:"",
					contentType : "text/html; charset=utf-8",
					error : function(XMLHttpRequest, textStatus, errorThrown) {
						//alert(XMLHttpRequest.status);
						//alert(XMLHttpRequest.readyState);
						//alert(textStatus);
						alert(1);
					},
					success : function(data) {
						if (data != "true") {
							alert(data + "库存不够。");
						}
					}
				});

		return true;

	}

	function calcuincome() {
		var actweight = $('input:text[id="actweight"]').val();
		var unitprice = $('input:text[id="unitprice"]').val();
		var additionalincome = 0;
		var x = document.getElementsByName("additionalsequence");
		var i = x.length;
		var flag = "";
		var additionalmaterialstring = "";
		for (var j = 1; j <= i; j++) {
			var additionalmaterialname = $(
					'input:text[id="additionalmaterialname' + j + '"]').val();
			var additionalmaterialcount = $(
					'input:text[id="additionalmaterialcount' + j + '"]').val();
			var additionalmaterialunitprice = $(
					'input:text[id="additionalmaterialunitprice' + j + '"]')
					.val();

			if (additionalmaterialname != "") {
				if (flag == "") {
					additionalmaterialstring = additionalmaterialname + ";"
							+ additionalmaterialcount + ";"
							+ additionalmaterialunitprice;
					flag = "has";
				} else {
					additionalmaterialstring = additionalmaterialstring + ","
							+ additionalmaterialname + ";"
							+ additionalmaterialcount + ";"
							+ additionalmaterialunitprice;
				}
				additionalincome = additionalincome + additionalmaterialcount
						* additionalmaterialunitprice;
			}
		}
		$('#additionalmaterialstring').val(additionalmaterialstring);
		$('#actincome').val(actweight * unitprice);
		$("#additionalincome").val(additionalincome);
		$('#totalincome').val(actweight * unitprice + additionalincome);
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
			<sf:form servletRelativeAction="jxfordertotransactionout"
				onsubmit="return check()" method="post" modelAttribute="order"
				cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				<div class="panel panel-default">
					<sf:input path="id" type="hidden" maxlength="20"
						cssClass="form-control" />
					<div class="panel-heading">
						<sp:message code="label.checkstock" />
					</div>

					<div class="form-group">
						<sf:label path="orderId" cssClass="col-sm-2 control-label">
							<sp:message code="label.order" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="orderId" maxlength="20" cssClass="form-control"
								readonly="true" />
						</div>
						<sf:label path="customer.name" cssClass="col-sm-2 control-label">
							<sp:message code="label.customer" />
						</sf:label>
						<div class="col-sm-2">
							<sf:input path="customer.name" maxlength="20"
								cssClass="form-control" readonly="true" />
						</div>
					</div>
				</div>
				<div class="panel panel-default">
					<table id="searchmaterialtable"
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th><sp:message code="label.id" /></th>
								<th><sp:message code="label.material" /></th>
								<th><sp:message code="label.thickness" /></th>
								<th><sp:message code="label.color" /></th>
								<th><sp:message code="label.length" /></th>
								<th><sp:message code="label.count" /></th>
								<th><sp:message code="label.pinming" /></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ordermaterial" items="${order.materialorderlist}"
								varStatus="loop">

								<tr>
									<td><input id='sequence<c:out value="${loop.index+1}"/>'
										name="sequence" type="text" readonly="readonly"
										value="${loop.index+1}"
										style='width: 100px; padding: 4px; border: none; background: transparent;' />
										<input id='identity<c:out value="${loop.index+1}"/>'
										name="identity" type="hidden" value="${ordermaterial.id}"
										style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='materialId<c:out value="${loop.index+1}"/>'
										name="materialId" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderMaterialId}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='thickness<c:out value="${loop.index+1}"/>'
										name="thickness" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderThickness}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='color<c:out value="${loop.index+1}"/>'
										name="color" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderColor}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='length<c:out value="${loop.index+1}"/>'
										name="length" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderLength}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input
										id='materialcount<c:out value="${loop.index+1}"/>'
										name="materialcount" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderCount}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input
										id='matchmaterialPinming<c:out value="${loop.index+1}"/>'
										name="matchmaterialPinming" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderPinming}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' /> <input
										id='materialtype<c:out value="${loop.index+1}"/>'
										name="materialtype" type="hidden"
										value='<c:out value="${ordermaterial.type}"/>'
										style='width: 100px; padding: 4px;' /> <input
										id='searchmaterial<c:out value="${loop.index+1}"/>'
										name="searchmaterial" type="hidden"
										value='<c:out value="${ordermaterial.mormgidentity}"/>'
										style='width: 100px; padding: 4px;' /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<sf:input path="additionalmaterialstring"
					id="additionalmaterialstring" name="additionalmaterialstring"
					type="hidden" />
				<div class="panel panel-default">
					<table id="additionalmaterialtable"
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th><sp:message code="label.id" /></th>
								<th><sp:message code="label.additionalmaterial" /></th>
								<th>数量</th>
								<th>单价</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="additionalmaterial"
								items="${additionalmateriallist}" varStatus="loop">
								<tr>
									<td><input
										id='additionalsequence<c:out value="${loop.index+1}"/>'
										name="additionalsequence" type="text" value="${loop.index+1}"
										style='width: 100px; padding: 4px; border: none; background: transparent;' readonly="readonly" /></td>
									<td><input
										id='additionalmaterialname<c:out value="${loop.index+1}"/>'
										name="additionalmaterialname" type="text"
										value='<c:out value="${additionalmaterial[0]}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' readonly="readonly" /></td>
									<td><input
										id='additionalmaterialcount<c:out value="${loop.index+1}"/>'
										name="additionalmaterialcount" type="text"
										value='<c:out value="${additionalmaterial[1]}"/>'
										style='width: 100px; padding: 4px; border: none; background: transparent;' readonly="readonly" /></td>
									<td><input
										id='additionalmaterialunitprice<c:out value="${loop.index+1}"/>'
										name="additionalmaterialunitprice" type="text" required="required"
										value='<c:out value="${additionalmaterial[2]}"/>'
										onkeyup='calcuincome()' style='width: 100px; padding: 4px;' /></td>
								</tr>
							</c:forEach>
					</table>
				</div>
				<input id="matchmaterial" name="matchmaterial" type="hidden"
					value="abc">
				<div class="form-group">
					<sf:label path="salesman.name" cssClass="col-sm-2 control-label">
						备注
					</sf:label>
					<div class="col-sm-2">
						<sf:textarea path="memo" cols="60" rows="6" />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">
						<sp:message code="label.calweight" />
					</label>
					<div class="col-sm-2">
						<c:out value="${order.actweight}"/>
					</div>
					<sf:label path="actweight" cssClass="col-sm-2 control-label">
						<sp:message code="label.actweight" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input id="actweight" path="actweight" required="true"
							onkeyup='calcuincome()' maxlength="20" cssClass="form-control" />
					</div>
					<sf:label path="unitprice" cssClass="col-sm-2 control-label">
						<sp:message code="label.unitprice" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input id="unitprice" path="unitprice" required="true" onkeyup="calcuincome()"
							maxlength="20" cssClass="form-control" />
					</div>
				</div>

				<div class="form-group">
					<sf:label path="actincome" cssClass="col-sm-2 control-label">
						铝材金额
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="actincome" required="true" maxlength="20"
							cssClass="form-control" />
					</div>
					<sf:label path="additionalincome" cssClass="col-sm-2 control-label">
						辅料总金额
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="additionalincome" maxlength="20"
							cssClass="form-control" />
					</div>
					<sf:label path="totalincome" cssClass="col-sm-2 control-label">
						汇总金额
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="totalincome" maxlength="20"
							cssClass="form-control" />
					</div>
				</div>

				<div class="form-group">
					<div class="col-sm-4">
						<div class="checkbox">
							<label> <sf:checkbox path="ispaid" /> <sp:message
									code="label.payment" />
							</label>
						</div>
						<c:if test="${order.jxforderstatus=='completed'}">
							<div class="col-md-offset-0 col-sm-1">
								<button type="button" class="btn btn-default"
									onclick="javascript:location='<c:url value="/jxforder/savepayment?id=${order.id}&ispaid=false"/>'">
									<sp:message code="label.saveunpaid" />
								</button>
							</div>
							<div class="col-md-offset-3 col-sm-1">
								<button type="button" class="btn btn-default"
									onclick="javascript:location='<c:url value="/jxforder/savepayment?id=${order.id}&ispaid=true"/>'">
									<sp:message code="label.savepaid" />
								</button>
							</div>
						</c:if>
					</div>
				</div>
				<div class="form-group">
					<c:if test="${order.jxforderstatus!='completed'}">
						<div class="col-md-offset-2 col-sm-1">
							<button type="submit" class="btn btn-primary">
								<sp:message code="label.transactionsout" />
							</button>
						</div>
						<div class="col-md-offset-2 col-sm-1">
							<button type="button" class="btn btn-default"
								onclick="javascript:location='<c:url value="/jxforder/editjxforder?id=${order.id}" />'">
								<sp:message code="label.edit" />
							</button>
						</div>
					</c:if>

					<div class="col-md-offset-2 col-sm-1">
						<button type="button" class="btn btn-default"
							onclick="history.go(-1);">
							<sp:message code="operate.cancel" />
						</button>
					</div>
					<div class="col-md-offset-2 col-sm-1">
						<button type="button" class="btn btn-default"
							onclick="javascript:location='<c:url value="/jxforder/printmatchmaterialforjxforder?id=${order.id}" />'">
							<sp:message code="label.print" />
						</button>
					</div>
				</div>
			</sf:form>

		</div>
	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
