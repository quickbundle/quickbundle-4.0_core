<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
<xsl:param name="thisFilePathName">
			<xsl:value-of select="$javaPackageTableDir"/>.util.exception --> <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.util.exception;

import org.quickbundle.base.exception.RmRuntimeException;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception extends RmRuntimeException {
	/**
	 * 构造函数
	 */
	public <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception() {
		super();
	}
    /**
     * 构造函数:
     * @param msg
     */
    public <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception(String msg) {
        super(msg);
    }
    
    /**
     * 构造函数:
     * @param t
     */
    public <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception(Throwable t) {
        super(t);
    }

    /**
     * 构造函数:
     * @param msg
     * @param t
     */
    public <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception(String msg, Throwable t) {
        super(msg, t);
    }
    
	/**
     * 构造函数:
     * @param msg
     * @param t
     * @param returnObj
     */
    public <xsl:value-of select="$tableFormatNameUpperFirst"/>Exception(String msg, Throwable t, Object returnObj) {
        super(msg, t, returnObj);
    }
}
</xsl:template>
</xsl:stylesheet>
