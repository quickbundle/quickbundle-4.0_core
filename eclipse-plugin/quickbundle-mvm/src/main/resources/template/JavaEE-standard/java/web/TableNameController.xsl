<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table[1]">
		<xsl:value-of select="str:getJavaFileComment($authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.quickbundle.base.web.page.RmPageVo;
import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.service.<xsl:value-of select="$tableFormatNameUpperFirst"/>Service;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo;
</xsl:for-each>
import org.quickbundle.third.excel.StatisticExport;
import org.quickbundle.tools.helper.RmJspHelper;
import org.quickbundle.tools.helper.RmPopulateHelper;
import org.quickbundle.tools.helper.RmSqlHelper;
import org.quickbundle.tools.helper.RmVoHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * list                  /<xsl:value-of select="@tableDirName"/>
 * insert page      GET  /<xsl:value-of select="@tableDirName"/>/insert
 * insert action    POST /<xsl:value-of select="@tableDirName"/>/insert
 * update page      GET  /<xsl:value-of select="@tableDirName"/>/update/{id}
 * update action    POST /<xsl:value-of select="@tableDirName"/>/update
 * delete action    POST /<xsl:value-of select="@tableDirName"/>/delete
 * detail                /<xsl:value-of select="@tableDirName"/>/detail/{id}
 * reference             /<xsl:value-of select="@tableDirName"/>/reference
 * statistic             /<xsl:value-of select="@tableDirName"/>/statistic
 * statistic table       /<xsl:value-of select="@tableDirName"/>/statistic/table
 *   export              /<xsl:value-of select="@tableDirName"/>/statistic/table/export
 * statistic chart       /<xsl:value-of select="@tableDirName"/>/statistic/chart
 * statistic flash       /<xsl:value-of select="@tableDirName"/>/statistic/flash
 *   data                /<xsl:value-of select="@tableDirName"/>/statistic/flash/data
 * import page      GET  /<xsl:value-of select="@tableDirName"/>/import
 * import action    POST /<xsl:value-of select="@tableDirName"/>/import
 * ajax                  /<xsl:value-of select="@tableDirName"/>/ajax
 */

<xsl:value-of select="str:getClassComment($authorName)"/>

@Controller
@RequestMapping(value = "/<xsl:value-of select="@tableDirName"/>")
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>Controller implements <xsl:value-of select="$ITableNameConstants"/> {

    @Autowired
    private <xsl:value-of select="$tableFormatNameUpperFirst"/>Service <xsl:value-of select="$tableFormatNameLowerFirst"/>Service;
    
    /**
     * 简单查询，分页显示，支持表单回写
     */
    @RequestMapping(value = "")
    public String list(Model model, HttpServletRequest request) {
        String queryCondition = getQueryCondition(request);  //从request中获得查询条件
        RmPageVo pageVo = RmJspHelper.transctPageVo(request, <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.getCount(queryCondition));
        String orderStr = RmJspHelper.getOrderStr(request);  //得到排序信息
        List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> beans = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.list(queryCondition, orderStr, pageVo.getStartIndex(), pageVo.getPageSize());  //按条件查询全部,带排序
        RmJspHelper.saveOrderStr(orderStr, request);  //保存排序信息
        model.addAttribute(REQUEST_QUERY_CONDITION, queryCondition);
        model.addAttribute(REQUEST_BEANS, beans);  //把结果集放入request
        model.addAttribute(REQUEST_WRITE_BACK_FORM_VALUES, RmVoHelper.getMapFromRequest((HttpServletRequest) request));  //回写表单
        return "<xsl:value-of select="$jspSourceTableDir"/>/list<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }
    
    /**
     * 跳转到新增页
     */
    @RequestMapping(value = "insert", method = RequestMethod.GET)
    public String insertForm(Model model) {
        model.addAttribute("bean", new <xsl:value-of select="$TableNameVo"/>());
        model.addAttribute("action", "insert");
        return "<xsl:value-of select="$jspSourceTableDir"/>/insert<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }
    
    /**
     * 从页面表单获取信息注入vo，并插入单条记录
     */
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    public String insert(HttpServletRequest request, @Valid <xsl:value-of select="$TableNameVo"/> vo, RedirectAttributes redirectAttributes) {
        RmVoHelper.markCreateStamp(request,vo);  //打创建时间,IP戳<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        vo.setBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>(RmPopulateHelper.populateVos(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo.class, request, TABLE_PK_<xsl:value-of select="@tableName"/>, TABLE_NAME_<xsl:value-of select="@tableName"/> + RM_NAMESPACE_SPLIT_KEY));
        RmVoHelper.markCreateStamp(request, vo.getBody());
</xsl:for-each>
        <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.insert(vo);  //插入单条记录
        redirectAttributes.addFlashAttribute("message", "创建成功");
        return "redirect:/<xsl:value-of select="@tableDirName"/>";
    }
    
    /**
     * 从页面的表单获取单条记录id，查出这条记录的值，并跳转到修改页面
     */
    @RequestMapping(value = "update/{id}", method = RequestMethod.GET)
    public String updateForm(@PathVariable("id") String id, Model model) {
        <xsl:value-of select="$TableNameVo"/> bean = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.get(new Long(id));
        model.addAttribute(REQUEST_BEAN, bean);  //把vo放入request
        model.addAttribute("action", "update");
        return "<xsl:value-of select="$jspSourceTableDir"/>/insert<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }
    
    /**
     * 从页面表单获取信息注入vo，并修改单条记录
     */
    @RequestMapping(value = "update", method = RequestMethod.POST)
    public String update(HttpServletRequest request, @Valid <xsl:value-of select="$TableNameVo"/> vo, RedirectAttributes redirectAttributes) {
        RmVoHelper.markModifyStamp(request,vo);  //打修改时间,IP戳<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        vo.setBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>(RmPopulateHelper.populateVos(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo.class, request, TABLE_PK_<xsl:value-of select="@tableName"/>, TABLE_NAME_<xsl:value-of select="@tableName"/> + RM_NAMESPACE_SPLIT_KEY));
        RmVoHelper.markModifyStamp(request, vo.getBody());
</xsl:for-each>
        int count = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.update(vo);  //更新单条记录
        redirectAttributes.addFlashAttribute("message", "更新成功: " + count);
        return "redirect:/<xsl:value-of select="@tableDirName"/>";
    }
    
    /**
     * 从页面的表单获取单条记录id并删除，如request.id为空则删除多条记录（request.ids）
     */
    @RequestMapping(value = "delete", method = RequestMethod.POST)
    public String delete(HttpServletRequest request, RedirectAttributes redirectAttributes) {
        int deleteCount = 0;  //定义成功删除的记录数
        String id = request.getParameter(REQUEST_ID);
        if(id != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> id.length() > 0) {
            deleteCount = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.delete(new Long(id));
        } else {
            Long[] ids = RmJspHelper.getLongArrayFromRequest(request, REQUEST_IDS); //从request获取多条记录id
            if (ids != null <xsl:value-of select="$charAmp"/><xsl:value-of select="$charAmp"/> ids.length != 0) {
                deleteCount += <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.delete(ids);  //删除多条记录
            }
        }
        redirectAttributes.addFlashAttribute("message", "删除成功: " + deleteCount);
        return "redirect:/<xsl:value-of select="@tableDirName"/>";
    }

    /**
     * 从页面的表单获取单条记录id，并察看这条记录的详细信息
     */
    @RequestMapping(value = "detail/{id}")
    public String detail(@PathVariable("id") String id, Model model, HttpServletRequest request) {
        <xsl:value-of select="$TableNameVo"/> bean = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.get(new Long(id));
        model.addAttribute(REQUEST_BEAN, bean);  //把vo放入request
        if(RM_YES.equals(request.getParameter(REQUEST_IS_READ_ONLY))) {
            model.addAttribute(REQUEST_IS_READ_ONLY, request.getParameter(REQUEST_IS_READ_ONLY));
        }
        return "<xsl:value-of select="$jspSourceTableDir"/>/detail<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }
    
    /**
     * 参照信息查询，带简单查询，分页显示，支持表单回写
     */
    @RequestMapping(value = "reference")
    public String reference(Model model, HttpServletRequest request) {
        list(model, request);
        model.addAttribute(REQUEST_REFERENCE_INPUT_TYPE, request.getParameter(REQUEST_REFERENCE_INPUT_TYPE));  //传送输入方式,checkbox或radio
        return "<xsl:value-of select="$jspSourceTableDir"/>/util/reference<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }

    /**
     * 表格式统计
     */
    @RequestMapping(value = "statistic/table")
    public String statisticTable(Model model, HttpServletRequest request) {
        String rowKeyField = "parent_message_id";  //定义行统计关键字
        String columnKeyField = "id";  //定义列统计关键字
        String queryCondition = getQueryCondition(request);  //从request中获得查询条件
        List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> beans = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.list(queryCondition, null);  //查询出全部结果
        StatisticExport sh = new StatisticExport(beans, rowKeyField, columnKeyField, "父消息ID\\主键");
        model.addAttribute(REQUEST_STATISTIC_HANDLER, sh);  //把结果集放入request
        model.addAttribute(REQUEST_WRITE_BACK_FORM_VALUES, RmVoHelper.getMapFromRequest((HttpServletRequest) request));  //回写表单
        return "<xsl:value-of select="$jspSourceTableDir"/>/util/statistic<xsl:value-of select="$tableFormatNameUpperFirst"/>_table";
    }
    
    /**
     * 表格式统计
     */
    @RequestMapping(value = "statistic/table/export")
    public String statisticTableExport(Model model, HttpServletRequest request) {
        statisticTable(model, request);
        return "support/downloadStatisticExcel";
    }
    
    /**
     * 图表式统计
     */
    @RequestMapping(value = "statistic/chart")
    public String statisticChart(Model model) {
        return "<xsl:value-of select="$jspSourceTableDir"/>/util/statistic<xsl:value-of select="$tableFormatNameUpperFirst"/>_chart";
    }
    /**
     * Flash式统计
     */
    @RequestMapping(value = "statistic/flash")
    public String statisticFlash(Model model) {
        return "<xsl:value-of select="$jspSourceTableDir"/>/util/statistic<xsl:value-of select="$tableFormatNameUpperFirst"/>_flash";
    }
    /**
     * Flash式统计
     */
    @RequestMapping(value = "statistic/flash/data")
    public String statisticFlashData(Model model) {
        return "<xsl:value-of select="$jspSourceTableDir"/>/util/statistic<xsl:value-of select="$tableFormatNameUpperFirst"/>_flashData";
    }
    
    /**
     * 跳转到导入页
     */
    @RequestMapping(value = "import", method = RequestMethod.GET)
    public String importDataForm(Model model) {
        return "<xsl:value-of select="$jspSourceTableDir"/>/import<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }
    /**
     * 执行导入
     */
    @RequestMapping(value = "import", method = RequestMethod.POST)
    public String importData(Model model) {
        model.addAttribute("isSubmit", "1");
        return "<xsl:value-of select="$jspSourceTableDir"/>/import<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }
    /**
     * 跳转到Ajax页
     */
    @RequestMapping(value = "ajax")
    public String ajax(Model model) {
        return "<xsl:value-of select="$jspSourceTableDir"/>/ajax/list<xsl:value-of select="$tableFormatNameUpperFirst"/>";
    }

    
    /**
     * 从request中获得查询条件
     * @param request
     * @return 拼装好的SQL条件字符串
     */
    public static String getQueryCondition(HttpServletRequest request) {
        String queryCondition = null;
        if(request.getAttribute(REQUEST_QUERY_CONDITION) != null) {  //如果request.getAttribute中有，就不取request.getParameter
            queryCondition = request.getAttribute(REQUEST_QUERY_CONDITION).toString();
        } else {
            List<xsl:value-of select="$charLt"/>String> lQuery = new ArrayList<xsl:value-of select="$charLt"/>String>();
            
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".biz_keyword", request.getParameter("biz_keyword"), RmSqlHelper.TYPE_CHAR_LIKE));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".sender_id", request.getParameter("sender_id"), RmSqlHelper.TYPE_CHAR_LIKE));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".parent_message_id", request.getParameter("parent_message_id"), RmSqlHelper.TYPE_CUSTOM, "='", "'"));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".owner_org_id", request.getParameter("owner_org_id"), RmSqlHelper.TYPE_CHAR_LIKE));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".template_id", request.getParameter("template_id"), RmSqlHelper.TYPE_CHAR_LIKE));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".is_affix", request.getParameter("is_affix"), RmSqlHelper.TYPE_CUSTOM, "='", "'"));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".record_id", request.getParameter("record_id"), RmSqlHelper.TYPE_CHAR_LIKE));
                
            lQuery.add(RmSqlHelper.buildQueryStr(TABLE_NAME + ".message_xml_context", request.getParameter("message_xml_context"), RmSqlHelper.TYPE_CHAR_LIKE));
                
            queryCondition = RmSqlHelper.appendQueryStr(lQuery.toArray(new String[0]));
        }
        return queryCondition;
    }

    /**
     * 跳转到中间表RM_M_MESSAGE_USER页
     */
    @RequestMapping(value = "rm_m_message_user")
    public String rm_m_message_user(Model model) {
        return "<xsl:value-of select="$jspSourceTableDir"/>/middle/listRm_m_message_user";
    }
    
    /**
     * 插入中间表RM_M_MESSAGE_USER数据
     */
    @RequestMapping(value = "insertRm_m_message_user", method = RequestMethod.POST)
    public String insertRm_m_message_user(HttpServletRequest request, @Valid <xsl:value-of select="$TableNameVo"/> vo, RedirectAttributes redirectAttributes) {
        String message_id = request.getParameter("message_id");
        String[] user_ids = request.getParameter("user_ids").split(",");
        int count = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.insertRm_m_message_user(message_id, user_ids).length;
        redirectAttributes.addFlashAttribute("message", "插入了" + count + "条记录!");
        redirectAttributes.addAttribute("message_id", message_id);
        return "redirect:/<xsl:value-of select="@tableDirName"/>/rm_m_message_user";
    }
    
    /**
     * 删除中间表RM_M_MESSAGE_USER数据
     */
    @RequestMapping(value = "deleteRm_m_message_user", method = RequestMethod.POST)
    public String deleteRm_m_message_user(HttpServletRequest request, @Valid <xsl:value-of select="$TableNameVo"/> vo, RedirectAttributes redirectAttributes) {
        String message_id = request.getParameter("message_id");
        String[] user_ids = request.getParameter("user_ids").split(",");
        int count = <xsl:value-of select="$tableFormatNameLowerFirst"/>Service.deleteRm_m_message_user(message_id, user_ids);
        redirectAttributes.addFlashAttribute("message", "删除了" + count + "条记录!");
        redirectAttributes.addAttribute("message_id", message_id);
        return "redirect:/<xsl:value-of select="@tableDirName"/>/rm_m_message_user";
    }
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
		<xsl:variable name="jspSourceTableDir" select="$jspSourceTableDir"/>
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
