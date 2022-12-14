<%@ page import="model.ContactType" %>
<%@ page import="model.TextSection" %>
<%@ page import="model.ListSection" %>
<%@ page import="model.OrganizationSection" %>
<%@ page import="util.HtmlUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="css/style.css">
    <jsp:useBean id="resume" type="model.Resume" scope="request"/>
    <title>Resume ${resume.fullName}</title>
</head>
<body>
<jsp:include page="fragments/header.jsp"/>
<section>
    <h1>${resume.fullName}&nbsp;<a href="resume?uuid=${resume.uuid}&action=edit"><img src="img/pencil.png"></a></h1>
    <p>
        <c:forEach var="contactEntry" items="${resume.contacts}">
            <jsp:useBean id="contactEntry" type="java.util.Map.Entry<model.ContactType, java.lang.String>"/>
            <%=contactEntry.getKey().toHtml(contactEntry.getValue())%><br/>
        </c:forEach>
    </p>
    <hr>
    <table cellpadding="2">
        <c:forEach var="sectionEntry" items="${resume.sections}">
            <jsp:useBean id="sectionEntry" type="java.util.Map.Entry<model.SectionType, model.Section>"/>
            <c:set var="type" value="${sectionEntry.key}"/>
            <c:set var="section" value="${sectionEntry.value}"/>
            <jsp:useBean id="section" type="model.Section"/>
            <tr>
                <td><h3><a name="type.name">${type.title}</a></h3></td>
                <c:if test="${type=='OBJECTIVE'}">
                    <td>
                        <h3><%=((TextSection) section).getContent()%>
                        </h3>
                    </td>
                </c:if>
            </tr>
            <c:if test="${type!='OBJECTIVE'}">
                <c:choose>
                    <c:when test="${type=='PERSONAL'}">
                        <tr>
                            <td colspan=2>
                                <h3><%=((TextSection) section).getContent()%>
                                </h3>
                            </td>
                        </tr>
                    </c:when>
                    <c:when test="${type=='QUALIFICATIONS' || type=='ACHIEVEMENT'}">
                        <tr>
                            <td colspan=2>
                                <ul>
                                    <c:forEach var="item" items="<%=((ListSection) section).getItems()%>">
                                        <li>${item}</li>
                                    </c:forEach>
                                </ul>
                            </td>
                        </tr>
                    </c:when>
                    <c:when test="${type=='EXPERIENCE' || type=='EDUCATION'}">
                        <c:forEach var="org" items="<%=((OrganizationSection) section).getOrganizations()%>">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty org.homePage.url}">
                                            <h3>${org.homePage.name}</h3>
                                        </c:when>
                                        <c:otherwise>
                                            <h3><a href="${org.homePage.url}">${org.homePage.name}</a></h3>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <c:forEach var="position" items="${org.positions}">
                                <jsp:useBean id="position" type="model.Organization.Position"/>
                                <tr>
                                    <td><%=HtmlUtil.formatDates(position)%>
                                    </td>
                                    <td><b>${position.title}</b><br>${position.description}</td>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </c:when>
                </c:choose>
            </c:if>
        </c:forEach>
    </table>
    <button onclick="window.history.back()">OK</button>
</section>
<jsp:include page="fragments/footer.jsp"/>
</body>
</html>
