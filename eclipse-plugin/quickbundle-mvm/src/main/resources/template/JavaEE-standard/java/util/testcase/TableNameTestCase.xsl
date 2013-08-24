<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
<xsl:param name="thisFilePathName">
			<xsl:value-of select="$javaPackageTableDir"/>.util.testcase --> <xsl:value-of select="$tableFormatNameUpperFirst"/>TestCase.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.util.testcase;

import org.quickbundle.base.beans.factory.RmBeanFactory;
import org.quickbundle.base.test.RmTestCase;
import org.quickbundle.tools.helper.RmVoHelper;

import <xsl:value-of select="$javaPackageTableDir"/>.service.I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service;
import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>TestCase extends RmTestCase implements <xsl:value-of select="$ITableNameConstants"/> {
    
    /**
     * 得到BS对象
     * 
     * @return BS对象
     */
    private I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service getService() {
        return (I<xsl:value-of select="$tableFormatNameUpperFirst"/>Service) RmBeanFactory.getBean(SERVICE_KEY); //得到Service对象,受事务控制
    }

    /**
     * 插入单条记录
     */
    public void insert() {
        <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
        RmVoHelper.objectToString(getService().insert(vo));
    }

    /**
     * 删除单条记录，删除多条记录
     */
    public void delete() {
        RmVoHelper.objectToString(getService().delete("1000100000000000001"));
        RmVoHelper.objectToString(getService().delete(new String[] { "1000100000000000001" }));
    }

    /**
     * 根据Id进行查询
     */
    public void find() {
        RmVoHelper.objectToString(getService().find("1000100000000000001"));
    }

    /**
     * 更新单条记录
     */
    public void update() {
        <xsl:value-of select="$TableNameVo"/> vo = new <xsl:value-of select="$TableNameVo"/>();
        RmVoHelper.objectToString(getService().update(vo));
    }

    /**
     * 查询总记录数
     */
    public void getRecordCount() {
        RmVoHelper.objectToString(getService().getRecordCount(" 1=1 "));
    }

    /**
     * 通过查询条件获得所有的VO对象列表
     */
    public void queryByCondition() {
        RmVoHelper.objectToString(getService().queryByCondition(" 1=1 ", null));
        RmVoHelper.objectToString(getService().queryByCondition(" 1=1 ", DEFAULT_ORDER_BY_CODE, 1, 10 ));
    }
}
</xsl:template>
</xsl:stylesheet>
