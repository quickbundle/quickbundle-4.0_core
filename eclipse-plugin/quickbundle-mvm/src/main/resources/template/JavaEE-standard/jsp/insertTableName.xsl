<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" encoding="UTF-8" escape-uri-attributes="yes"/>
	<!--处理table-->
	<xsl:template match="table">
<xsl:value-of select="$charLt"/>%@ page contentType="text/html; charset=UTF-8" language="java" %>
<xsl:if test="column[@isBuild='true' and (@humanDisplayType='rm.dictionary.select' or @humanDisplayType='rm.dictionary.checkbox')]">
<xsl:value-of select="$charLt"/>%@page import="org.quickbundle.tools.helper.RmJspHelper"%>
<xsl:value-of select="$charLt"/>%@page import="org.quickbundle.project.RmGlobalReference"%>
</xsl:if>
<xsl:value-of select="$charLt"/>%@ page import="org.quickbundle.tools.helper.RmVoHelper" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$TableNameVoFullPath"/>" %>
<xsl:value-of select="$charLt"/>%@ page import="<xsl:value-of select="$ITableNameConstantsFullPath"/>" %>
<xsl:value-of select="$charLt"/>%  //判断是否为修改页面
  	<xsl:value-of select="$TableNameVo"/> resultVo = null;  //定义一个临时的vo变量
	boolean isModify = false;  //定义变量,标识本页面是否修改(或者新增)
	if(request.getParameter("isModify") != null) {  //如果从request获得参数"isModify"不为空
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
	var rmActionName = "<xsl:value-of select="$TableNameAction"/>";
	function insert_onClick(){  //插入单条数据
    	form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/" + rmActionName + ".do?cmd=insert";
	    form.submit();
	}
  	function update_onClick(id){  //保存修改后的单条数据
    	if(!getConfirm()) {  //如果用户在确认对话框中点"取消"
  			return false;
		}
	    form.action="<xsl:value-of select="$charLt"/>%=request.getContextPath()%>/" + rmActionName + ".do?cmd=update";
    	form.submit();
	}
<xsl:value-of select="$charLt"/>/script>
<xsl:value-of select="$charLt"/>/head>
<xsl:value-of select="$charLt"/>body>
<xsl:value-of select="$charLt"/>form name="form" method="post">
<xsl:value-of select="$charLt"/>br/>
<xsl:value-of select="$charLt"/>table class="mainTable">
	<xsl:value-of select="$charLt"/>tr>
		<xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
		<xsl:value-of select="$charLt"/>td width="35%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
		<xsl:value-of select="$charLt"/>td align="right" width="20%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
		<xsl:value-of select="$charLt"/>td width="25%"><xsl:value-of select="$charNbsp"/><xsl:value-of select="$charLt"/>/td>
	<xsl:value-of select="$charLt"/>/tr>
	<xsl:apply-templates mode="buildTableColumn_insertInput"/>
<xsl:value-of select="$charLt"/>/table>
  
<xsl:value-of select="$charLt"/>input type="hidden" name="<xsl:value-of select="$tablePkFormatLower"/>" value="">

<xsl:value-of select="$charLt"/>table align="center">
	<xsl:value-of select="$charLt"/>tr>
		<xsl:value-of select="$charLt"/>td><xsl:value-of select="$charLt"/>br>
			<xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_save" value="保存" onclickto="javascript:<xsl:value-of select="$charLt"/>%=isModify?"update_onClick()":"insert_onClick()"%>"/>
			<xsl:value-of select="$charLt"/>input type="button" class="button_ellipse" id="button_cancel" value="取消" onclick="javascript:history.go(-1)"/>
			<xsl:value-of select="$charLt"/>input type="reset" class="button_ellipse" id="button_reset" value="重置"/>
		<xsl:value-of select="$charLt"/>/td>
	<xsl:value-of select="$charLt"/>/tr>
<xsl:value-of select="$charLt"/>/table>

<xsl:value-of select="$charLt"/>/form>
<xsl:value-of select="$charLt"/>/body>
<xsl:value-of select="$charLt"/>/html>
<xsl:value-of select="$charLt"/>script type="text/javascript">
<xsl:value-of select="$charLt"/>%  //取出要修改的那条记录，并且回写表单
	if(isModify) {  //如果本页面是修改页面
		out.print(RmVoHelper.writeBackMapToForm(RmVoHelper.getMapFromVo(resultVo)));  //输出表单回写方法的脚本
  	}
%>
<xsl:value-of select="$charLt"/>/script>
</xsl:template>
</xsl:stylesheet>
