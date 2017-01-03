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
	function selectSalesman() {
		var val = $('input:radio[name="id"]:checked').val();
		var salesmanname = $('input:radio[name="id"]:checked')
				.parent().next().text();
		if (val == null) {
			alert("Please select one salesman");
			return false;
		} else {
			$('#salesmanid', window.opener.document).val(val);
			salesmanname = salesmanname.replace("\n", "").replace("\n",
					"").trim();
			$('#salesmanname', window.opener.document)
					.val(salesmanname);
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

			<sf:form servletRelativeAction="searchsalesman" method="post"
				modelAttribute="salesman" cssClass="form-horizontal">
				<sf:errors path="*" cssClass="alert alert-danger" element="div" />
				<div class="panel panel-default">
					<table
						class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>&nbsp;</th>
								<th><sp:message code="label.name" /></th>
								<th><sp:message code="label.phone" /></th>
							</tr>
						</thead>
						<c:forEach var="salesman" items="${salesmanlist}" varStatus="loop">
							<tr>
								<td><sf:radiobutton path="id"
										value="${salesman.id}" /></td>
								<td><c:out value="${salesman.name}" /></td>
								<td><c:out value="${salesman.phone}" /></td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</sf:form>
		</div>
		<div class="col-sm-2">
					<button type="button" class="btn btn-primary"
						onclick="selectSalesman()">
						<sp:message code="operate.save" />
					</button>
				</div>

	</div>

	<%@ include file="../includes/footer.jsp"%>
</body>
</html>
