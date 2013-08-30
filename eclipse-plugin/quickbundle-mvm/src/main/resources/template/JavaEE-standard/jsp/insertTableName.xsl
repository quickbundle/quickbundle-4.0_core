<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" encoding="UTF-8" escape-uri-attributes="yes"/>
	<!--处理table-->
	<xsl:template match="table[1]">
<xsl:value-of select="$charLt"/>%@ page contentType="text/html; charset=UTF-8" language="java" %>
<xsl:value-of select="$charLt"/>%@ page import="org.quickbundle.tools.helper.RmVoHelper" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>" %>
<xsl:value-of select="$charLt"/>%  //判断是否为修改页面
    <xsl:value-of select="$TableNameVo"/> resultVo = null;  //定义一个临时的vo变量
    boolean isModify = false;  //定义变量,标识本页面是否修改(或者新增)
    if(request.getParameter("isModify") != null || "update".equals(request.getAttribute("action"))) {
        isModify = true;  //赋值isModify为true
        if(request.getAttribute(<xsl:value-of select="$ITableNameConstants"/>.REQUEST_BEAN) != null) {  //如果request中取出的bean不为空
            resultVo = (<xsl:value-of select="$TableNameVo"/>)request.getAttribute(<xsl:value-of select="$ITableNameConstants"/>.REQUEST_BEAN);  //从request中取出vo, 赋值给resultVo
        }
    }
%>
<xsl:value-of select="$charLt"/>!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<xsl:value-of select="$charLt"/>html>
<xsl:value-of select="$charLt"/>head>
<xsl:value-of select="$charLt"/>%@ include file="/jsp/include/rmGlobal.jsp" %>
<xsl:value-of select="$charLt"/>%@ include file="/jsp/include/rmGlobal_insert.jsp" %>
<xsl:value-of select="$charLt"/>meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<xsl:value-of select="$charLt"/>title><xsl:value-of select="$charLt"/>bean:message key="qb.web_title"/><xsl:value-of select="$charLt"/>/title>
<xsl:value-of select="$charLt"/>script type="text/javascript">
    var rmActionName = "<xsl:value-of select="$tableFormatNameUpperFirst"/>Action";
    function insert_onClick(){  //插入单条数据
        form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/<xsl:value-of select="@tableDirName"/>/insert";
        form.submit();
    }
    function update_onClick(id){  //保存修改后的单条数据
        if(!getConfirm()) {  //如果用户在确认对话框中点"取消"
            return false;
        }
        form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/<xsl:value-of select="@tableDirName"/>/update";
        form.submit();
    }
<xsl:value-of select="$charLt"/>/script>
<xsl:value-of select="$charLt"/>/head>
<xsl:value-of select="$charLt"/>body>
<xsl:value-of select="$charLt"/>form name="form" method="post">

<xsl:value-of select="$charLt"/>div class="button_area">
    <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_save" value="保存" onclickto="javascript:${action}_onClick()"/>
    <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_cancel" value="取消" onclick="javascript:history.go(-1)"/>
    <xsl:value-of select="$charLt"/>input type="reset" class="button_ellipse" id="button_reset" value="重置"/>
<xsl:value-of select="$charLt"/>/div>

<xsl:value-of select="$charLt"/>table class="mainTable">
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td width="35%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td width="25%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>span class="style_required_red">* <xsl:value-of select="$charLt"/>/span><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("biz_keyword")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field" name="biz_keyword" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("biz_keyword")%>" value="" maxLength="25" validate="notNull;"/>
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>span class="style_required_red">* <xsl:value-of select="$charLt"/>/span><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("sender_id")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field" name="sender_id" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("sender_id")%>" value="0" maxLength="9" validate="notNull;"/>
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("parent_message_id")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field_reference"  hiddenInputId="parent_message_id" name="parent_message_id_name" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("parent_message_id")%>" value="" /><xsl:value-of select="$charLt"/>input type="hidden" name="parent_message_id"><xsl:value-of select="$charLt"/>img class="refButtonClass" src="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/images/09.gif" onclick="javascript:getReference(new Array(form.parent_message_id, form.parent_message_id_name), '<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/', '<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/<xsl:value-of select="$tableFormatNameUpperFirst"/>Action.do?cmd=queryReference<xsl:value-of select="$charAmp"/>referenceInputType=radio');"/>
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("owner_org_id")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field" name="owner_org_id" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("owner_org_id")%>" value="" maxLength="25" />
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("template_id")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field" name="template_id" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("template_id")%>" value="" maxLength="9" />
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("is_affix")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field" name="is_affix" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("is_affix")%>" value="" maxLength="1" />
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("record_id")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td>
            <xsl:value-of select="$charLt"/>input type="text" class="text_field" name="record_id" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("record_id")%>" value="" maxLength="25" />
        <xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>tr>
        <xsl:value-of select="$charLt"/>td align="right"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("message_xml_context")%><xsl:value-of select="$charLt"/>/td>
        <xsl:value-of select="$charLt"/>td colspan="3">
            <xsl:value-of select="$charLt"/>textarea class="textarea_limit_words" cols="60" rows="5" name="message_xml_context" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY.get("message_xml_context")%>" maxLength="32767" ><xsl:value-of select="$charLt"/>/textarea>
        <xsl:value-of select="$charLt"/>/td>
    <xsl:value-of select="$charLt"/>/tr>
    <xsl:value-of select="$charLt"/>/table>
  
<xsl:value-of select="$charLt"/>input type="hidden" name="<xsl:value-of select="$tablePkFormatLower"/>" value="" />

<xsl:value-of select="$charLt"/>!-- child table begin -->
<xsl:value-of select="$charLt"/>div id="rowTabs">
    <xsl:value-of select="$charLt"/>ul>
        <xsl:value-of select="$charLt"/>li><xsl:value-of select="$charLt"/>a href="#rowTabs-<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>%>"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_DISPLAY_<xsl:value-of select="@tableName"/> %>列表<xsl:value-of select="$charLt"/>/a><xsl:value-of select="$charLt"/>/li>
        <xsl:value-of select="$charLt"/>li style="position:relative;float:right;padding-right:10px">
            <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_addRow" value="增行" onclick="javascript:addRow_onClick()" title="增加一行"/>
            <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_removeRow" value="删行" onclick="javascript:removeRow_onClick();" title="删除所选的行"/>
            <xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_copyRow" value="复制" onclick="javascript:copyRow_onClick();" title="复制所选的行"/>
        <xsl:value-of select="$charLt"/>/li>
    <xsl:value-of select="$charLt"/>/ul>
    <xsl:value-of select="$charLt"/>div id="rowTabs-<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>%>">
        <xsl:value-of select="$charLt"/>div class="rowContainer">
            <xsl:value-of select="$charLt"/>table class="rowTable" namespace="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>%>" id="rowTable">
                <xsl:value-of select="$charLt"/>tr class="trheader">
                    <xsl:value-of select="$charLt"/>td align="left" style="width:3%;"><xsl:value-of select="$charLt"/>input type="checkbox" class="rowCheckboxControl" style="display:none;"/>选择<xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("message_id")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("receiver_id")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("is_handle")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("handle_date")%><xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td align="left" style="width:8%;"><xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("handle_result")%><xsl:value-of select="$charLt"/>/td>
                <xsl:value-of select="$charLt"/>/tr>
                <xsl:value-of select="$charLt"/>!-- 新增行原型 -->
                <xsl:value-of select="$charLt"/>tr class="rowPrototype">
                    <xsl:value-of select="$charLt"/>td align="center"> 
                        <xsl:value-of select="$charLt"/>input type="checkbox" name="rmRowSelecter"/>
                        <xsl:value-of select="$charLt"/>input type="hidden" name="<xsl:value-of select="$tablePkFormatLower"/>"/>
                    <xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>
                        <xsl:value-of select="$charLt"/>input type="text" name="message_id" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("message_id")%>" value="" />
                    <xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>
                        <xsl:value-of select="$charLt"/>input type="text" name="receiver_id" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("receiver_id")%>" value="" />
                    <xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>
                        <xsl:value-of select="$charLt"/>input type="text" name="is_handle" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("is_handle")%>" value="" />
                    <xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>
                        <xsl:value-of select="$charLt"/>input type="text" name="handle_date" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("handle_date")%>" value="" />
                    <xsl:value-of select="$charLt"/>/td>
                    <xsl:value-of select="$charLt"/>td>
                        <xsl:value-of select="$charLt"/>input type="text" name="handle_result" inputName="<xsl:value-of select="$charLt"/>%=<xsl:value-of select="$ITableNameConstants"/>.TABLE_COLUMN_DISPLAY_<xsl:value-of select="@tableName"/>.get("handle_result")%>" value="" />
                    <xsl:value-of select="$charLt"/>/td>
                <xsl:value-of select="$charLt"/>/tr>
            <xsl:value-of select="$charLt"/>/table>
        <xsl:value-of select="$charLt"/>/div>
    <xsl:value-of select="$charLt"/>/div>
<xsl:value-of select="$charLt"/>/div>
<xsl:value-of select="$charLt"/>!-- child table end -->

<xsl:value-of select="$charLt"/>/form>
<xsl:value-of select="$charLt"/>/body>
<xsl:value-of select="$charLt"/>/html>
<xsl:value-of select="$charLt"/>script type="text/javascript">
<xsl:value-of select="$charLt"/>%  //取出要修改的那条记录，并且回写表单
    if(isModify) {  //如果本页面是修改页面
        out.print(RmVoHelper.writeBackMapToForm(RmVoHelper.getMapFromVo(resultVo)));  //输出表单回写方法的脚本
        out.print(RmVoHelper.writeBackListToRowTable(<xsl:value-of select="$ITableNameConstants"/>.TABLE_NAME_<xsl:value-of select="@tableName"/>, resultVo.getBody()));  //输出表单回写方法的脚本
    }
%>
<xsl:value-of select="$charLt"/>/script>
</xsl:template>
</xsl:stylesheet>
