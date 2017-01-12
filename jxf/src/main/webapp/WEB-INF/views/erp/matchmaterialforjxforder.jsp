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
			// check all material count set
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
			// check all material set
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
			// check additional material
			x = document.getElementsByName("additionalmaterialcount");
			l = x.length;
			for (var j = 1; j <= l; j++) {
				var searchmaterial = $(
						'input:text[id="additionalmaterialcount' + j + '"]').val();
				if (searchmaterial == "") {
					alert("请编辑此订单，为第" + j + "行辅料添加数量。");
					return false;
				}
			}

			return true;
		}
		return false;
	}
	function checkenoughstock() {
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
							return false;
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
	function selectallmo() {
		var objselectall = document.getElementsByName("selectall");
		var objpreparetoout = document.getElementsByName("preparetoout");
		if (objselectall[0].checked == true) {
			for (k in objpreparetoout) {
				if (objpreparetoout[k].disabled == true)
					continue;
				objpreparetoout[k].checked = true;
			}
		} else {
			for (k in objpreparetoout) {
				if (objpreparetoout[k].disabled == true)
					continue;
				objpreparetoout[k].checked = false;
			}
		}
	}
	function outselected() {
		var checked = check();
		if (checked == false)
			return false;
		//var objpreparetoout = document.getElementsByName("preparetoout");
		var objpreparetoout = $('input:checkbox[name="preparetoout"]');
		var objoutcount = $('input:text[name="outcount"]');
		var check_val = [];
		//this for out count, if 0 then no. if >0, then out the count
		var outcount_val = [];
		for (k in objpreparetoout) {
			if (objpreparetoout[k].disabled == true)
				continue;
			else if (objpreparetoout[k].checked) {
				if (objpreparetoout[k].value != ""
						&& objpreparetoout[k].value != "undefined") {
					check_val.push(objpreparetoout[k].value);
					//alert(objoutcount[k].value);
					outcount_val.push(objoutcount[k].value);
				}
			}
		}
		if (check_val != "") {
			$
					.ajax({
						type : "POST",
						dataType : "text",
						url : "${pageContext.request.contextPath}/jxforder/checkmaterialorderstock?identitylist="
								+ check_val+"&outcountlist="+outcount_val,
						//data:"",
						contentType : "text/html; charset=utf-8",
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							//alert(XMLHttpRequest.status);
							//alert(XMLHttpRequest.readyState);
							//alert(textStatus);
							alert("出错了");
						},
						success : function(data) {
							if (data != "true") {
								alert(data + "库存不够。");
							} else {
								//alert("可以出库");
								$
										.ajax({
											type : "POST",
											dataType : "text",
											url : "${pageContext.request.contextPath}/jxforder/outmaterialorderstock?identitylist="
													+ check_val+"&outcountlist="+outcount_val,
											//data:"",
											contentType : "text/html; charset=utf-8",
											error : function(XMLHttpRequest,
													textStatus, errorThrown) {
												//alert(XMLHttpRequest.status);
												//alert(XMLHttpRequest.readyState);
												//alert(textStatus);
												alert("出错了");
											},
											success : function(data) {
												alert("出库成功");
												//window.location.reload();
												for (k in objpreparetoout) {
													if (objpreparetoout[k].checked) {
														//obj[k].parent().previous().text="completed";
														objpreparetoout[k].disabled = true;
														//$($obj[k].parent().previousSibling().children().get(0)).find('input').val("1");
													}
												}
											}
										});
							}
						}
					});
		} else {
			alert("请选择要出库的物料。");
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
			<sf:form servletRelativeAction="jxfordertotransactionout"
				method="post" modelAttribute="order" cssClass="form-horizontal">
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
								<th>状态</th>
								<th>剩余数量</th>
								<th>出货</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="ordermaterial" items="${order.materialorderlist}"
								varStatus="loop">

								<tr>
									<td><input id='sequence<c:out value="${loop.index+1}"/>'
										name="sequence" type="text" readonly="readonly"
										value="${loop.index+1}"
										style='width: 60px; padding: 4px; border: none; background: transparent;' />
										<input id='identity<c:out value="${loop.index+1}"/>'
										name="identity" type="hidden" value="${ordermaterial.id}"
										style='width: 60px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='materialId<c:out value="${loop.index+1}"/>'
										name="materialId" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderMaterialId}"/>'
										style='width: 60px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='thickness<c:out value="${loop.index+1}"/>'
										name="thickness" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderThickness}"/>'
										style='width: 60px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='color<c:out value="${loop.index+1}"/>'
										name="color" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderColor}"/>'
										style='width: 60px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input id='length<c:out value="${loop.index+1}"/>'
										name="length" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderLength}"/>'
										style='width: 60px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input
										id='materialcount<c:out value="${loop.index+1}"/>'
										name="materialcount" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderCount}"/>'
										style='width: 60px; padding: 4px; border: none; background: transparent;' /></td>
									<td><input
										id='matchmaterialPinming<c:out value="${loop.index+1}"/>'
										name="matchmaterialPinming" type="text" readonly="readonly"
										value='<c:out value="${ordermaterial.orderPinming}"/>'
										style='width: 130px; padding: 4px; border: none; background: transparent;' />
										<input id='materialtype<c:out value="${loop.index+1}"/>'
										name="materialtype" type="hidden"
										value='<c:out value="${ordermaterial.type}"/>'
										style='width: 60px; padding: 4px;' /> <input
										id='searchmaterial<c:out value="${loop.index+1}"/>'
										name="searchmaterial" type="hidden"
										value='<c:out value="${ordermaterial.mormgidentity}"/>'
										style='width: 60px; padding: 4px;' /></td>
									<td><input
										value='<c:out value="${ordermaterial.materialstatus=='completed'?'出库完成':'需出库'}"/>'
										style='width: 80px; padding: 4px; border: none; background: transparent;' />
									</td>
									<!-- partial out count -->
									
									<td>
									<c:if
											test="${ordermaterial.missingcount!=0}">
											<input name="outcount"
										value='<c:out value="${ordermaterial.missingcount}"/>'
										style='width: 80px; padding: 4px;' /></c:if>
										<c:if
											test="${ordermaterial.missingcount==0}">
											<input name="outcount"
										value='<c:out value="${ordermaterial.missingcount}"/>'
										style='width: 80px; padding: 4px; border: none; background: transparent;' /></c:if>
									</td>
									<td><c:if
											test="${ordermaterial.materialstatus=='completed'}">
											<input type="checkbox" name="preparetoout"
												disabled="disabled" checked="checked" />
										</c:if> <c:if test="${ordermaterial.materialstatus != 'completed'}">
											<input type="checkbox" name="preparetoout"
												value="${ordermaterial.id}" />
										</c:if></td>

								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="form-group">
					<div style="float: right">
						<label> 全选 </label> <input type="checkbox" name="selectall"
							onclick="selectallmo()">
						<button type="button" class="btn btn-primary" style="align: right"
							onclick="outselected()">出库</button>
					</div>
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
										style='width: 80px; padding: 4px; border: none; background: transparent;'
										readonly="readonly" /></td>
									<td><input
										id='additionalmaterialname<c:out value="${loop.index+1}"/>'
										name="additionalmaterialname" type="text"
										value='<c:out value="${additionalmaterial[0]}"/>'
										style='width: 80px; padding: 4px; border: none; background: transparent;'
										readonly="readonly" /></td>
									<td><input
										id='additionalmaterialcount<c:out value="${loop.index+1}"/>'
										name="additionalmaterialcount" type="text"
										value='<c:out value="${additionalmaterial[1]}"/>'
										style='width: 80px; padding: 4px; border: none; background: transparent;'
										readonly="readonly" /></td>
									<td><input
										id='additionalmaterialunitprice<c:out value="${loop.index+1}"/>'
										name="additionalmaterialunitprice" type="text"
										required="required"
										value='<c:out value="${additionalmaterial[2]}"/>'
										onkeyup='calcuincome()' style='width: 80px; padding: 4px;' /></td>
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
					<sf:label path="expresscount" cssClass="col-sm-2 control-label">
						物流件数
					</sf:label>
					<div class="col-sm-2">
						<sf:textarea path="expresscount" cols="20" rows="1" />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label"> <sp:message
							code="label.calweight" />
					</label>
					<div class="col-sm-2">
						<c:out value="${order.calweight}" />
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
						<sf:input id="unitprice" path="unitprice" required="true"
							onkeyup="calcuincome()" maxlength="20" cssClass="form-control" />
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
					</div>
				</div>
				<div class="form-group">
					<div class="col-md-offset-2 col-sm-1">
						<button type="submit" class="btn btn-primary">保存</button>
					</div>

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
