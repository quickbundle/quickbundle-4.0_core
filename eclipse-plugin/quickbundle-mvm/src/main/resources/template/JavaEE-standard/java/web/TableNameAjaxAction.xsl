<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:param name="thisFilePathName">
			<xsl:value-of select="$TableNameActionPackage"/> --> <xsl:value-of select="$TableNameAjaxAction"/>.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$TableNameActionPackage"/>;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.quickbundle.base.web.page.RmPageVo;
import org.quickbundle.tools.helper.RmJspHelper;

import <xsl:value-of select="$ITableNameServiceFullPath"/>;
import <xsl:value-of select="$ITableNameConstantsFullPath"/>;
import <xsl:value-of select="$TableNameVoFullPath"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$TableNameAjaxAction"/> extends <xsl:value-of select="$TableNameAction"/> implements <xsl:value-of select="$ITableNameConstants"/> {
    /**
     * 批量保存，没有主键的insert，有主键的update
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward insertUpdateBatch(ActionMapping mapping, ActionForm form, final HttpServletRequest request, HttpServletResponse response) throws Exception {
    	super.insertUpdateBatch(mapping, form, request, response);
        return mapping.findForward(FORWARD_OUTPUT_AJAX_PAGE);
    }

    /**
     * 从页面的表单获取多条记录id，并删除多条记录
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward deleteMulti(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	super.deleteMulti(mapping, form, request, response);
    	return mapping.findForward(FORWARD_OUTPUT_AJAX_PAGE);
    }
    
    /**
     * 简单查询，分页显示
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward simpleQuery(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        <xsl:value-of select="$ITableNameService"/> service = getService();
        String queryCondition = getQueryCondition(request);  //从request中获得查询条件
        RmPageVo pageVo = RmJspHelper.transctPageVo(request, getCount(queryCondition));
        String orderStr = RmJspHelper.getOrderStr(request);  //得到排序信息
        List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> beans = service.queryByCondition(queryCondition, orderStr, pageVo.getStartIndex(), pageVo.getPageSize(), true);  //按条件查询全部,带排序
        //如果采用下边这句，就是不带翻页的，同时需要删掉listAjax页面的pagingToolbar定义
        //beans = service.queryByCondition(queryCondition, orderStr, -1, -1, true);  //查询全部,带排序
        request.setAttribute(REQUEST_BEANS, beans);  //把结果集放入request
        return mapping.findForward(FORWARD_OUTPUT_AJAX_PAGE);
    }
}
</xsl:template>
</xsl:stylesheet>
