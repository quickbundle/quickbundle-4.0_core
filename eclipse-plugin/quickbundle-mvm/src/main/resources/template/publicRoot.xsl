<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY xmlBr "&#10;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:str="http://www.quickbundle.org" version="2.0" exclude-result-prefixes="str">
	<!--定义输出格式-->
	<xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" standalone="yes" indent="yes"/>
	<!--定义如何处理空白字符-->
	<xsl:strip-space elements=""/>
	<xsl:preserve-space elements="*"/>
	<!--抽取XML中的公共元素-->
	<!--定义是否DEBUG状态-->
	<xsl:variable name="debug" select="true"/>
	<!--定义/database中的全局变量-->
	<xsl:variable name="driver" select="/meta/database/driver"/>
	<xsl:variable name="url" select="/meta/database/url"/>
	<xsl:variable name="userName" select="/meta/database/userName"/>
	<xsl:variable name="password" select="/meta/database/password"/>
	<xsl:variable name="dbProductName" select="/meta/database/dbProductName"/>
	<!--定义/myTables中第1个table的全局变量-->
	<xsl:variable name="tableName" select="/meta/tables/table[1]/@tableName"/>
	<xsl:variable name="tableNameDisplay" select="/meta/tables/table[1]/@tableNameDisplay"/>
	<xsl:variable name="tableFilterKeyword" select="/meta/tables/table[1]/@tableFilterKeyword"/>
	<xsl:variable name="tablePk" select="/meta/tables/table[1]/@tablePk"/>
	<xsl:variable name="statisticColumn" select="/meta/tables/table[1]/@statisticColumn"/>
	<xsl:variable name="keyColumn" select="/meta/tables/table[1]/@keyColumn"/>
	<xsl:variable name="tableComment" select="/meta/tables/table[1]/@tableComment"/>
	<!--定义处理过的表名全局变量-->
	<xsl:variable name="tableFormatName" select="str:filter($tableName, $tableFilterKeyword, 'specify')"/>
	<xsl:variable name="tableFormatNameLower" select="lower-case($tableFormatName)"/>
	<xsl:variable name="tableFormatNameUpperFirst" select="str:upperFirstTableName($tableName, $tableFilterKeyword, 'specify')"/>
	<!--定义处理过的主键和外键-->
	<xsl:variable name="tablePkFormat" select="str:filter($tablePk, /meta/tables/table[1]/column[@columnName=$tablePk]/@filterKeyword, /meta/tables/table[1]/column[@columnName=$tablePk]/@filterType)"/>
	<xsl:variable name="tablePkFormatLower" select="lower-case($tablePkFormat)"/>
	<xsl:variable name="tablePkDisplay" select="/meta/tables/table[1]/column[@columnName=$tablePk]/@columnNameDisplay"/>
	<xsl:variable name="statisticColumnFormat" select="str:filter($statisticColumn, /meta/tables/table[1]/column[@columnName=$statisticColumn]/@filterKeyword, /meta/tables/table[1]/column[@columnName=$statisticColumn]/@filterType)"/>
	<xsl:variable name="statisticColumnFormatLower" select="lower-case($statisticColumnFormat)"/>
	<xsl:variable name="statisticColumnDisplay" select="/meta/tables/table[1]/column[@columnName=$statisticColumn]/@columnNameDisplay"/>
	<xsl:variable name="keyColumnFormat" select="str:filter($keyColumn, /meta/tables/table[1]/column[@columnName=$keyColumn]/@filterKeyword, /meta/tables/table[1]/column[@columnName=$keyColumn]/@filterType)"/>
	<xsl:variable name="keyColumnFormatLower" select="lower-case($keyColumnFormat)"/>
	<xsl:variable name="keyColumnDisplay" select="/meta/tables/table[1]/column[@columnName=$keyColumn]/@columnNameDisplay"/>
	<!--定义全局标记分隔符，为了统一过滤并批量替换-->
	<xsl:variable name="division">RM_FLAG_DIVISION</xsl:variable>
	<!--定义全局分隔符-->
	<xsl:variable name="prefix">_</xsl:variable>
	<!--<-->
	<xsl:variable name="charLt">&lt;</xsl:variable>
	<!-->-->
	<xsl:variable name="charGt">&gt;</xsl:variable>
	<!--&-->
	<xsl:variable name="charAmp">&amp;</xsl:variable>
	<!--"-->
	<xsl:variable name="charQuot">&quot;</xsl:variable>
	<!--'-->
	<xsl:variable name="charApos">&apos;</xsl:variable>
	<!--nbsp-->
	<xsl:variable name="charNbsp">&amp;nbsp;</xsl:variable>
	<!--回车-->
	<xsl:variable name="charBr">&#13;</xsl:variable>
	<!--tab键-->
	<xsl:variable name="charTab">&#09;</xsl:variable>
	<!--空格字符串-->
	<xsl:variable name="charSpace">&#32;</xsl:variable>
	<!--自定义函数，取key之前的部分，如果无key，则返回整个字符串-->
	<xsl:function name="str:substring-before2">
		<xsl:param name="word" as="xs:string"/>
		<xsl:param name="keyStr" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="substring-before($word, $keyStr)=''">
				<xsl:sequence select="$word"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="substring-before($word, $keyStr)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!--自定义函数，把字符串首字母变大写，其余字母小写-->
	<xsl:function name="str:upperFirst">
		<xsl:param name="word" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="not(string-length($word)=0)">
				<xsl:sequence select="concat(upper-case(substring($word,1,1)),lower-case(substring($word,2,string-length($word))))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$word"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!--（带规则）自定义函数，针对表名操作，把字符串首字母变大写，其余字母采取不同策略-->
	<xsl:function name="str:upperFirstTableName">
		<xsl:param name="word" as="xs:string"/>
		<xsl:param name="filterKeyword" as="xs:string"/>
		<xsl:param name="filterType" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="$filterType='default'">
				<xsl:sequence select="concat(upper-case(substring($word,1,1)),substring($word,2))"/>
			</xsl:when>
			<xsl:when test="$filterType='lowerCase'">
				<xsl:sequence select="str:upperFirst($word)"/>
			</xsl:when>
			<xsl:when test="$filterType='specify'">
				<xsl:sequence select="concat(upper-case(substring($filterKeyword,1,1)),substring($filterKeyword,2))"/>
			</xsl:when>
			<xsl:when test="$filterType='minus'">
				<xsl:sequence select="str:upperFirst(str:filter($word, $filterKeyword, $filterType))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="str:upperFirst($word)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!--（带规则）自定义函数，根据指定的规则处理字符串-->
	<xsl:function name="str:filter">
		<xsl:param name="word" as="xs:string"/>
		<xsl:param name="filterKeyword" as="xs:string"/>
		<xsl:param name="filterType" as="xs:string"/>
		<xsl:choose>
			<xsl:when test="$filterType='default'">
				<xsl:sequence select="$word"/>
			</xsl:when>
			<xsl:when test="$filterType='lowerCase'">
				<xsl:sequence select="lower-case($word)"/>
			</xsl:when>
			<xsl:when test="$filterType='specify'">
				<xsl:sequence select="$filterKeyword"/>
			</xsl:when>
			<xsl:when test="$filterType='minus'">
				<xsl:choose>
					<xsl:when test="string-length($word)=0">
						<xsl:sequence select="$word"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="starts-with(lower-case($word), lower-case($filterKeyword))">
								<xsl:sequence select="lower-case(substring($word, string-length($filterKeyword)+1))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:sequence select="lower-case($word)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="lower-case($word)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	<!--处理根元素-->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="text()|@*"/>
</xsl:stylesheet>
