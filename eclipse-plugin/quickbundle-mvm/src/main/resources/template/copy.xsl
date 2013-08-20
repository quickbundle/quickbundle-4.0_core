<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--定义输出格式-->
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" standalone="yes" indent="yes"/>
	<!--定义如何处理空白字符-->
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements=""/>
	<!--处理根元素-->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
