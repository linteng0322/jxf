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
	function selectCustomer() {
		var val = $('input:radio[name="id"]:checked').val();
		var customerFamilyName = $('input:radio[name="id"]:checked')
				.parent().next().text();
		if (val == null) {
			alert("Please select one customer");
			return false;
		} else {
			$('#customerIdentity', window.opener.document).val(val);
			customerFamilyName = customerFamilyName.replace("\n", "").replace("\n",
					"").trim();
			$('#customerFamilyName', window.opener.document)
					.val(customerFamilyName);
			window.close();
		}
	}
</script>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body class="home">
	<div id="page">
		<%@ include file="../includes/header.jsp"%>
		
		<div width:100%;">

			<sf:form servletRelativeAction="searchcustomer" method="post"
				modelAttribute="customer" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />

				<div class="form-group">
					<sf:label path="name" cssClass="col-sm-3 control-label">
						<sp:message code="label.client" />
					</sf:label>
					<div class="col-sm-2">
						<sf:input path="name" maxlength="20" cssClass="form-control" />
					</div>
					<div class="col-sm-2">
						<button type="submit" class="btn btn-primary">
							<sp:message code="label.search" />
						</button>
					</div>
				</div>
				
				<div class="panel panel-default">
					<table
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>&nbsp;</th>
								<th><sp:message code="label.client" /></th>
								<th><sp:message code="label.phone" /></th>
								<th><sp:message code="label.address" /></th>
							</tr>
						</thead>
						<c:forEach var="customer" items="${customerlist}" varStatus="loop">
							<tr>
								<td><sf:radiobutton path="id"
										value="${customer.id}" /></td>
								<td><c:out value="${customer.name}" /></td>
								<td><c:out value="${customer.phone}" /></td>
								<td><c:out value="${customer.address}" /></td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</sf:form>
		</div>
		<div class="col-sm-2">
					<button type="button" class="btn btn-primary"
						onclick="selectCustomer()">
						<sp:message code="operate.save" />
					</button>
				</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
