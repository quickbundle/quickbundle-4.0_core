<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" encoding="UTF-8" escape-uri-attributes="no"/>
	<!--处理table-->
	<xsl:template match="table[1]">
<xsl:value-of select="$charLt"/>%@ page contentType="text/html; charset=UTF-8" language="java" %>
<xsl:value-of select="$charLt"/>%@ page import="org.quickbundle.tools.helper.RmVoHelper" %>
<xsl:value-of select="$charLt"/>%@ page import="org.quickbundle.tools.helper.RmStringHelper" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>" %>
<xsl:value-of select="$charLt"/>%  //取出本条记录
    <xsl:value-of select="$TableNameVo"/> resultVo = null;  //定义一个临时的vo变量
    resultVo = (<xsl:value-of select="$TableNameVo"/>)request.getAttribute(<xsl:value-of select="$ITableNameConstants"/>.REQUEST_BEAN);  //从request中取出vo, 赋值给resultVo
    RmVoHelper.replaceToHtml(resultVo);  //把vo中的每个值过滤
%>
<xsl:value-of select="$charLt"/>!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<xsl:value-of select="$charLt"/>html>
<xsl:value-of select="$charLt"/>head>
<xsl:value-of select="$charLt"/>%@ include file="/jsp/include/rmGlobal.jsp" %>
<xsl:value-of select="$charLt"/>meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<xsl:value-of select="$charLt"/>title><xsl:value-of select="$charLt"/>bean:message key="qb.web_title"/><xsl:value-of select="$charLt"/>/title>
<xsl:value-of select="$charLt"/>script type="text/javascript">
    var rmActionName = "<xsl:value-of select="$tableFormatNameUpperFirst"/>Action";
    function find_onClick(){  //直接点到修改页面
        window.location.href="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/<xsl:value-of select="@tableDirName"/>/update/" + $("#head_id").val();
    }
    function delete_onClick(){  //直接点删除单条记录
        if(!getConfirm()) {  //如果用户在确认对话框中点"取消"
            return false;
        }
        form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/<xsl:value-of select="@tableDirName"/>/delete";
        form.submit();
    }  
<xsl:value-of select="$charLt"/>/script>
<xsl:value-of select="$charLt"/>/head>
<xsl:value-of select="$charLt"/>body>
<xsl:value-of select="$charLt"/>form name="form" method="post">

<xsl:value-of select="$charLt"/>div class="button_area">
    <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_update" value="修改" onclick="javascript:find_onClick();" />
    <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_delete" value="删除" onclickto="javascript:delete_onClick();" />
    <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_back" value="返回"  onclick="javascript:history.go(-1);" />
<xsl:value-of select="$charLt"/>/div>

<xsl:value-of select="$charLt"/>table class="mainTable">
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td width="35%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td width="25%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("biz_keyword")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.biz_keyword}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("sender_id")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.sender_id}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("parent_message_id")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.parent_message_id}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("owner_org_id")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.owner_org_id}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("template_id")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.template_id}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("is_affix")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.is_affix}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("record_id")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>${bean.record_id}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("message_xml_context")%>：<xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td colspan="3">${bean.message_xml_context}<xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>/table>

<xsl:value-of select="$charLt"/>input id="head_id" type="hidden" name="<xsl:value-of select="$tablePkFormatLower"/>" value="<xsl:value-of select="$charLt"/>%=RmStringHelper.prt(resultVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>())%>" />

<xsl:value-of select="$charLt"/>!-- child table begin -->
<xsl:value-of select="$charLt"/>div id="rowTabs">
    <xsl:value-of select="$charLt"/>ul>
        <xsl:value-of select="$charLt"/>li><xsl:value-of select="$charLt"/>a href="#rowTabs-<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>%>"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_DISPLAY_<xsl:value-of select="@tableName"/> %>列表<xsl:value-of select="$charLt"/>/a><xsl:value-of select="$charLt"/>/li>
        <xsl:value-of select="$charLt"/>li><xsl:value-of select="$charLt"/>a href="#rowTabs-rm_m_message_user">关联用户列表<xsl:value-of select="$charLt"/>/a><xsl:value-of select="$charLt"/>/li>
    <xsl:value-of select="$charLt"/>/ul>
    <xsl:value-of select="$charLt"/>div id="rowTabs-<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>%>">
        <xsl:value-of select="$charLt"/>div class="rowContainer">
            <xsl:value-of select="$charLt"/>table class="rowTable" namespace="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>%>" id="rowTable">
                <xsl:value-of select="$charLt"/>tr class="trheader">
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("message_id")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("receiver_id")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("is_handle")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("handle_date")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("handle_result")%><xsl:value-of select="$charLt"/>/td>
                <xsl:value-of select="$charLt"/>/tr>
            <xsl:value-of select="$charLt"/>c:forEach items="${bean.body}" var="v">
                <xsl:value-of select="$charLt"/>tr>
                    <xsl:value-of select="$charLt"/>td>${v.message_id}<xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>${v.receiver_id}<xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>${v.is_handle}<xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>${v.handle_date}<xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>${v.handle_result}<xsl:value-of select="$charLt"/>/td>
                <xsl:value-of select="$charLt"/>/tr>
            <xsl:value-of select="$charLt"/>/c:forEach>
            <xsl:value-of select="$charLt"/>/table>
        <xsl:value-of select="$charLt"/>/div>
    <xsl:value-of select="$charLt"/>/div>
    <xsl:value-of select="$charLt"/>div id="rowTabs-rm_m_message_user">
        <xsl:value-of select="$charLt"/>iframe id="tabInfo_frame" src="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/<xsl:value-of select="@tableDirName"/>/rm_m_message_user?message_id=<xsl:value-of select="$charLt"/>%=resultVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>()%>" frameborder="0" width="100%" height="500px" scrolling="yes"/>
    <xsl:value-of select="$charLt"/>/div>
<xsl:value-of select="$charLt"/>/div>
<xsl:value-of select="$charLt"/>!-- child table end -->

<xsl:value-of select="$charLt"/>/form>
<xsl:value-of select="$charLt"/>/body>
<xsl:value-of select="$charLt"/>/html>
	</xsl:template>
</xsl:stylesheet>