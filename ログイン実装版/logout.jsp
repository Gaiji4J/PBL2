<%--
  Created by IntelliJ IDEA.
  User: adu
  Date: 2017/10/05
  Time: 14:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate();    // セッションを無効にして、関連付けられたオブジェクトを解放
    response.sendRedirect("start.jsp");    // start.jspにリダイレクト
%>