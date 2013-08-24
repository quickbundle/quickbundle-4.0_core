<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:param name="thisFilePathName">
			<xsl:value-of select="$javaPackageTableDir"/>.web --> <xsl:value-of select="$tableFormatNameUpperFirst"/>Action.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.quickbundle.base.beans.factory.RmBeanFactory;
import org.quickbundle.base.cache.RmSqlCountCache;
import org.quickbundle.base.web.action.RmDispatchAction;
import org.quickbundle.base.web.page.RmPageVo;
import org.quickbundle.project.IGlobalConstants;
import org.quickbundle.tools.helper.RmJspHelper;
import org.quickbundle.tools.helper.RmPopulateHelper;
import org.quickbundle.tools.helper.RmSqlHelper;
import org.quickbundle.tools.helper.RmVoHelper;
<xsl:if test="contains(@customBundleCode, 'statistic')">
import org.quickbundle.tools.support.statistic.RmStatisticHandler;
</xsl:if>

import <xsl:value-of select="$javaPackageTableDir"/>.service.I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service;
import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>Action extends RmDispatchAction implements <xsl:value-of select="$ITableNameConstants"/> {

    /**
     * 得到Service对象
     * 
     * @return Service对象
     */
    public I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service getService() {
        return (I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service) RmBeanFactory.getBean(SERVICE_KEY);  //得到Service对象,受事务控制
    }

    /**
     * 从页面表单获取信息注入vo，并插入单条记录
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward insert(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
        RmPopulateHelper.populate(vo, request);  //从request中注值进去vo
        RmVoHelper.markCreateStamp(request,vo);  //打创建时间,IP戳
        String id = getService().insert(vo);  //插入单条记录
        request.setAttribute(IGlobalConstants.INSERT_FORM_ID, id);  //新增记录的id放入request属性
        return mapping.findForward(FORWARD_TO_QUERY_ALL);
    }

    /**
     * 从页面的表单获取单条记录id，并删除单条记录
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward delete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        int deleteCount = getService().delete(request.getParameter(REQUEST_ID));  //删除单条记录
        request.setAttribute(EXECUTE_ROW_COUNT, deleteCount);  //sql影响的行数放入request属性
        return mapping.findForward(FORWARD_TO_QUERY_ALL);
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
        String[] id = RmJspHelper.getArrayFromRequest(request, REQUEST_IDS);  //从request获取多条记录id
        int deleteCount = 0;  //定义成功删除的记录数
        if (id != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> id.length != 0) {
            deleteCount = getService().delete(id);  //删除多条记录
        }
        request.setAttribute(EXECUTE_ROW_COUNT, deleteCount);  //sql影响的行数放入request属性
        return mapping.findForward(FORWARD_TO_QUERY_ALL);
    }

    /**
     * 从页面的表单获取单条记录id，查出这条记录的值，并跳转到修改页面
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward find(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        detail(mapping, form, request, response);
        return mapping.findForward(FORWARD_UPDATE_PAGE);
    }

    /**
     * 从页面表单获取信息注入vo，并修改单条记录
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward update(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
        RmPopulateHelper.populate(vo, request);  //从request中注值进去vo
        RmVoHelper.markModifyStamp(request,vo);  //打修改时间,IP戳
        int count = getService().update(vo);  //更新单条记录
        request.setAttribute(EXECUTE_ROW_COUNT, count);  //sql影响的行数放入request属性
        return mapping.findForward(FORWARD_TO_QUERY_ALL);
    }
    
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
    	List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> lvo = RmPopulateHelper.populateAjax(<xsl:value-of select="$TableNameVo"/>.class, request);
    	for(<xsl:value-of select="$TableNameVo"/> vo : lvo) {
    		if(vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>().trim().length() > 0) {
    			RmVoHelper.markModifyStamp(request, vo);
    		} else {
    			RmVoHelper.markCreateStamp(request, vo);
    		}
    	}
    	int[] sum_insert_update = getService().insertUpdateBatch(lvo.toArray(new <xsl:value-of select="$TableNameVo"/>[0]));
    	request.setAttribute(REQUEST_OUTPUT_OBJECT, sum_insert_update);
        return mapping.findForward(FORWARD_TO_QUERY_ALL);
    }

    /**
     * 简单查询，分页显示，支持表单回写
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward simpleQuery(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service service = getService();
        String queryCondition = getQueryCondition(request);  //从request中获得查询条件
        RmPageVo pageVo = RmJspHelper.transctPageVo(request, getCount(queryCondition));
        String orderStr = RmJspHelper.getOrderStr(request);  //得到排序信息
        List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> beans = service.queryByCondition(queryCondition, orderStr, pageVo.getStartIndex(), pageVo.getPageSize());  //按条件查询全部,带排序
        //如果采用下边这句，就是不带翻页的，同时需要删掉list页面的page.jsp相关语句
        //beans = service.queryByCondition(queryCondition, orderStr);  //查询全部,带排序
        RmJspHelper.saveOrderStr(orderStr, request);  //保存排序信息
        request.setAttribute(REQUEST_QUERY_CONDITION, queryCondition);
        request.setAttribute(REQUEST_BEANS, beans);  //把结果集放入request
        request.setAttribute(REQUEST_WRITE_BACK_FORM_VALUES, RmVoHelper.getMapFromRequest((HttpServletRequest) request));  //回写表单
        return mapping.findForward(FORWARD_LIST_PAGE);
    }

    /**
     * 查询全部记录，分页显示，支持页面上触发的后台排序
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward queryAll(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setAttribute(REQUEST_QUERY_CONDITION, "");
        simpleQuery(mapping, form, request, response);
        return mapping.findForward(FORWARD_LIST_PAGE);
    }

    /**
     * 从页面的表单获取单条记录id，并察看这条记录的详细信息
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward detail(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        <xsl:value-of select="$TableNameVo"/> bean = getService().find(request.getParameter(REQUEST_ID));  //通过id获取vo
        request.setAttribute(REQUEST_BEAN, bean);  //把vo放入request
        if(RM_YES.equals(request.getParameter(REQUEST_IS_READ_ONLY))) {
            request.setAttribute(REQUEST_IS_READ_ONLY, request.getParameter(REQUEST_IS_READ_ONLY));
        }
        return mapping.findForward(FORWARD_DETAIL_PAGE);
    }

	<xsl:if test="contains(@customBundleCode, 'reference')">
    /**
     * 参照信息查询，带简单查询，分页显示，支持表单回写
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward queryReference(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        simpleQuery(mapping, form, request, response);
        request.setAttribute(REQUEST_REFERENCE_INPUT_TYPE, request.getParameter(REQUEST_REFERENCE_INPUT_TYPE));  //传送输入方式,checkbox或radio
        return mapping.findForward(FORWARD_REFERENCE_PAGE);
    }
	</xsl:if>
	    
    <xsl:if test="contains(@customBundleCode, 'statistic')">
    /**
     * 功能: 统计
     *
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward statistic(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String rowKeyField = "<xsl:value-of select="$statisticColumnFormatLower"/>";  //定义行统计关键字
        String columnKeyField = "<xsl:value-of select="$keyColumnFormatLower"/>";  //定义列统计关键字
        I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service service = getService();
        String queryCondition = getQueryCondition(request);  //从request中获得查询条件
        List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> beans = service.queryByCondition(queryCondition, null);  //查询出全部结果
        RmStatisticHandler sh = new RmStatisticHandler(beans, rowKeyField, columnKeyField, "<xsl:value-of select="$statisticColumnDisplay"/>\\<xsl:value-of select="$keyColumnDisplay"/>");
        request.setAttribute(REQUEST_STATISTIC_HANDLER, sh);  //把结果集放入request
        request.setAttribute(REQUEST_WRITE_BACK_FORM_VALUES, RmVoHelper.getMapFromRequest((HttpServletRequest) request));  //回写表单
        return mapping.findForward(FORWARD_STATISTIC_PAGE);
    }
    
    /**
     * 功能: 统计导出Excel
     *
     * @param mapping
     * @param form
     * @param request
     * @param response 
     * @return
     * @throws Exception
     */
    public ActionForward statistic_exportExcel(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
        statistic(mapping, form, request, response);
    	return mapping.findForward(FORWARD_DOWNLOAD_STATISTIC_FILE_PAGE);
    }
    </xsl:if>
    
    /**
     * 功能: 从request中获得查询条件
     *
     * @param request
     * @return
     */
    protected String getQueryCondition(HttpServletRequest request) {
        String queryCondition = null;
        if(request.getAttribute(REQUEST_QUERY_CONDITION) != null) {  //如果request.getAttribute中有，就不取request.getParameter
            queryCondition = request.getAttribute(REQUEST_QUERY_CONDITION).toString();
        } else {
			List<xsl:value-of select="$charLt"/>String> lQuery = new ArrayList<xsl:value-of select="$charLt"/>String>();
			<xsl:apply-templates mode="buildTableColumn_actionQueryCondition"/>
			queryCondition = RmSqlHelper.appendQueryStr(lQuery.toArray(new String[0]));
        }
        return queryCondition;
    }
    
    /**
     * 得到缓存中查询条件对应的count(*)记录数，如返回-1则执行查询
     * 
     * @param queryCondition
     * @return
     */
    protected int getCount(String queryCondition) {
    	int count = RmSqlCountCache.getCount(TABLE_NAME, queryCondition);
    	if(count <xsl:value-of select="$charLt"/> 0) {
    		count = getService().getRecordCount(queryCondition);
    		RmSqlCountCache.putCount(TABLE_NAME, queryCondition, count);
    	}
    	return count;
    }
<xsl:call-template name="buildMiddleAction"/>
}
</xsl:template>
	<!--处理后台查询的build查询条件-->
	<xsl:template match="column" mode="buildTableColumn_actionQueryCondition">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk) and @isBuild='true'">
			<xsl:choose>
				<!--处理 参照 && 数字 -->
				<xsl:when test="@humanDisplayType='rm.listReference' and (@dataType='java.math.BigDecimal' or @dataType='java.lang.Long' or @dataType='java.lang.Integer')">
			lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>"), RmSqlHelper.TYPE_CUSTOM, "=", ""));
				</xsl:when>
				<!--处理 状态位 || (参照&&字符)，小于3个字符-->
				<xsl:when test="(@dataType='java.lang.String' and @maxLength&lt;=3) or (@humanDisplayType='rm.listReference' and @dataType='java.lang.String')">
			lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>"), RmSqlHelper.TYPE_CUSTOM, "='", "'"));
				</xsl:when>
				<!--处理text或textarea，大于3个字符-->
				<xsl:when test="@dataType='java.lang.String' and @maxLength&gt;3">
			lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>"), RmSqlHelper.TYPE_CHAR_LIKE));
				</xsl:when>
				<!--处理时间参照-->
				<xsl:when test="@dataType='java.sql.Timestamp' or @dataType='java.sql.Date'">
        	lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>_from"), RmSqlHelper.TYPE_DATE_GREATER_EQUAL));
        	lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>_to"), RmSqlHelper.TYPE_DATE_LESS_EQUAL));	
				</xsl:when>
				<!--处理数字-->
				<xsl:when test="@dataType='java.math.BigDecimal' or @dataType='java.lang.Long' or @dataType='java.lang.Integer'">
        	lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>_from"), RmSqlHelper.TYPE_NUMBER_GREATER_EQUAL));
        	lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>_to"), RmSqlHelper.TYPE_NUMBER_LESS_EQUAL));
				</xsl:when>
				<xsl:otherwise>
			lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".<xsl:value-of select="$columnNameFormatLower"/>", request.getParameter("<xsl:value-of select="$columnNameFormatLower"/>"), RmSqlHelper.TYPE_CHAR_LIKE));
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--生成多对多表Action定义-->
	<xsl:template name="buildMiddleAction">
		<xsl:variable name="parentChildTable" select="@parentChildTable"/>
		<xsl:variable name="jspFullPath" select="$jspFullPath"/>
			<xsl:analyze-string select="$parentChildTable" regex=",">
				<xsl:non-matching-substring>
					<xsl:analyze-string select="." regex='^\s*([\w_]+)\.([\w_]+)=([\w_]+)\.([\w_]+)\|([\w_]+)=([\w_]+)\.([\w_]+)\(([\w_]+)\.([\w_]+)\)\s*$'>
						<xsl:matching-substring>
    /**
     * 功能: 插入中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward insert<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String <xsl:value-of select="lower-case(regex-group(4))"/> = request.getParameter("<xsl:value-of select="lower-case(regex-group(4))"/>");
    	String[] <xsl:value-of select="lower-case(regex-group(5))"/>s = request.getParameter("<xsl:value-of select="lower-case(regex-group(5))"/>s").split(",");
    	int count = getService().insert<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(<xsl:value-of select="lower-case(regex-group(4))"/>, <xsl:value-of select="lower-case(regex-group(5))"/>s).length;
    	return RmJspHelper.getForwardInstanceWithAlert("/<xsl:value-of select="$jspSourceTableDir"/>/middle/list<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>.jsp?<xsl:value-of select="lower-case(regex-group(4))"/>=" + <xsl:value-of select="lower-case(regex-group(4))"/>, "插入了" + count + "条记录!");
    }
    
    /**
     * 功能: 删除中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ActionForward delete<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String <xsl:value-of select="lower-case(regex-group(4))"/> = request.getParameter("<xsl:value-of select="lower-case(regex-group(4))"/>");
    	String[] <xsl:value-of select="lower-case(regex-group(5))"/>s = request.getParameter("<xsl:value-of select="lower-case(regex-group(5))"/>s").split(",");
    	int count = getService().delete<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(<xsl:value-of select="lower-case(regex-group(4))"/>, <xsl:value-of select="lower-case(regex-group(5))"/>s);
    	return RmJspHelper.getForwardInstanceWithAlert("/<xsl:value-of select="$jspSourceTableDir"/>/middle/list<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>.jsp?<xsl:value-of select="lower-case(regex-group(4))"/>=" + <xsl:value-of select="lower-case(regex-group(4))"/>, "删除了" + count + "条记录!");
    }
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
	</xsl:template>
</xsl:stylesheet>
