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
	
	function searchandadd(uiElement) {
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
		'${pageContext.request.contextPath}/transaction/searchelementtry?uiElement='+uiElement,
		'material', popup_property);
	}
	
	/* function searchandadd(uiElement) {
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
		'${pageContext.request.contextPath}/material/fillmaterialfororder?uiElement='+uiElement,
		'material', popup_property);
	} */
	
	function submitmatch(){
		var appendstring;
		var x = document.getElementsByName("sequence");
		var i = x.length;
		var materialorderstring;
		var flag = "";
		for (var j = 1; j <= i; j++) {
			var elementid = "sequence" + j;
			searchmaterial = "searchmaterial" + j;//materialorder identity
			var searchmaterial = $('input:hidden[id="' + elementid + '"]').val();
			elementid = "materialtype" + j;
			var materialtype = $('input:hidden[id="' + elementid + '"]').val();
			if (materialId!="") {
				if (flag == "") {
					appendstring = searchmaterial + ";" + materialtype;
							flag = "has";
				} else {
					appendstring = appendstring + "," + searchmaterial + ";" + materialtype;
				}
			}
			/* $('#materialchildrenstring', document)
			.append(materialId);
			alert($('#materialchildrenstring')); */
		}
		$('#matchmaterial').val(appendstring);
	}
	
	function check() {
		if(confirm('确实要出库吗?')){
			var x = document.getElementsByName("materialcount");
			var l = x.length;
			for (var j = 1; j <= l; j++) {
				var materialcount = $('input:text[id="materialcount' + j + '"]').val();
				if(materialcount=="")
					{
						alert("请编辑此订单，为第"+j+"行物料添加数量。");
						return false;
					}
			}
			
			x = document.getElementsByName("searchmaterial");
			l = x.length;
			for (var j = 1; j <= l; j++) {
				var searchmaterial = $('input:hidden[id="searchmaterial' + j + '"]').val();
				if(searchmaterial=="")
					{
						alert("请编辑此订单，匹配第"+j+"行。");
						return false;
					}
			}
		}
		$.ajax({         
	         type: "POST",
	         dataType : "text",
	         url:"${pageContext.request.contextPath}/jxforder/checkallenoughstock?identity=${order.id}",
	         //data:"",
	         contentType: "text/html; charset=utf-8",
	         error: function(XMLHttpRequest, textStatus, errorThrown) {
	             //alert(XMLHttpRequest.status);
	             //alert(XMLHttpRequest.readyState);
	             //alert(textStatus);
	             alert(1);
	         },
	         success: function(data) {
	        	 if(data!="true"){
	        		 alert(data+"库存不够。");
	        	 }
	         }
	     });
		
		return true;
       
       }
	
	function calcuincome(){
		var calweight = $('input:text[id="calweight"]').val();
		var unitprice = $('input:text[id="unitprice"]').val();
		$('#calincome').val(calweight*unitprice);
	}
	
</script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body class="home">
	<div id="page">

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
					<sf:label path="customer.name"
						cssClass="col-sm-2 control-label">
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
								<td style='width: 100px; padding: 4px;'><c:out value="${loop.index+1}"/></td>
								<td style='width: 100px; padding: 4px;'><c:out value="${ordermaterial.orderMaterialId}"/></td>
								<td style='width: 100px; padding: 4px;'><c:out value="${ordermaterial.orderThickness}"/></td>
								<td style='width: 100px; padding: 4px;'><c:out value="${ordermaterial.orderColor}"/></td>
								<td style='width: 100px; padding: 4px;'><c:out value="${ordermaterial.orderLength}"/></td>
								<td style='width: 100px; padding: 4px;'><c:out value="${ordermaterial.orderCount}"/></td>
								<td style='width: 100px; padding: 4px;'><c:out value="${ordermaterial.orderPinming}"/></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
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
									<td style='width: 100px; padding: 4px;'><c:out value="${loop.index+1}"/></td>
									<td style='width: 100px; padding: 4px;'><c:out value="${additionalmaterial[0]}"/></td>
									<td style='width: 100px; padding: 4px;'><c:out value="${additionalmaterial[1]}"/></td>
									<td style='width: 100px; padding: 4px;'><c:out value="${additionalmaterial[2]}"/></td>
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
				<%-- <sf:label path="calweight" cssClass="col-sm-2 control-label">
					<sp:message code="label.calweight" />
				</sf:label>
				<div class="col-sm-2">
					<sf:input path="calweight" maxlength="20" readonly="true"
						cssClass="form-control" />
				</div> --%>
				<label class="col-sm-2 control-label">
					<sp:message code="label.actweight" />
				</label>
				<div class="col-sm-1 control-label">
					<c:out value="${order.actweight}"/>
				</div>
				<sf:label path="unitprice" cssClass="col-sm-2 control-label">
					<sp:message code="label.unitprice" />
				</sf:label>
				<div class="col-sm-1 control-label">
					<c:out value="${order.unitprice}"/>
				</div>
			</div>

			<div class="form-group">
				<sf:label path="actincome" cssClass="col-sm-2 control-label">
					铝材金额
				</sf:label>
				<div class="col-sm-1 control-label">
					<c:out value="${order.actincome}"/>
				</div>
				<sf:label path="actincome" cssClass="col-sm-2 control-label">
					辅料金额
				</sf:label>
				<div class="col-sm-1 control-label">
					<c:out value="${order.additionalincome}"/>
				</div>
				<sf:label path="actincome" cssClass="col-sm-2 control-label">
					总金额
				</sf:label>
				<div class="col-sm-1 control-label">
					<c:out value="${order.totalincome}"/>
				</div>
			</div>
		</sf:form>


	</div>
</body>
</html>
