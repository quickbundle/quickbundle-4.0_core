<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table[1]">
		<xsl:value-of select="str:getJavaFileComment($authorName)"/>
<xsl:value-of select="$charLt"/>?xml version="1.0" encoding="UTF-8"?>
<xsl:value-of select="$charLt"/>!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" 
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<xsl:value-of select="$charLt"/>mapper namespace="<xsl:value-of select="$javaPackageTableDir"/>.dao.<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao">

  <xsl:value-of select="$charLt"/>insert id="insert" parameterType="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>">
    insert into <xsl:value-of select="@tableName"/> ( 
      ID, BIZ_KEYWORD, SENDER_ID, PARENT_MESSAGE_ID, OWNER_ORG_ID, TEMPLATE_ID, IS_AFFIX, RECORD_ID, 
      MESSAGE_XML_CONTEXT, USABLE_STATUS, MODIFY_DATE, MODIFY_IP, MODIFY_USER_ID ) 
    values ( 
      #{id}, #{biz_keyword}, #{sender_id}, #{parent_message_id}, #{owner_org_id}, #{template_id}, #{is_affix}, #{record_id}, 
      #{message_xml_context}, #{usable_status}, #{modify_date}, #{modify_ip}, #{modify_user_id} )
  <xsl:value-of select="$charLt"/>/insert>
    
  <xsl:value-of select="$charLt"/>delete id="delete" parameterType="int">
    delete from <xsl:value-of select="@tableName"/> where ID=#{id}
  <xsl:value-of select="$charLt"/>/delete>
  
  <xsl:value-of select="$charLt"/>delete id="deleteMulti" parameterType="int">
    delete from <xsl:value-of select="@tableName"/> where ID in 
    <xsl:value-of select="$charLt"/>foreach collection="array" index="index" item="item" open="(" separator="," close=")">  
      #{item}   
    <xsl:value-of select="$charLt"/>/foreach>
  <xsl:value-of select="$charLt"/>/delete>

  <xsl:value-of select="$charLt"/>update id="update" parameterType="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>">
    update <xsl:value-of select="@tableName"/> set 
      BIZ_KEYWORD=#{biz_keyword}, SENDER_ID=#{sender_id}, PARENT_MESSAGE_ID=#{parent_message_id}, OWNER_ORG_ID=#{owner_org_id}, 
      TEMPLATE_ID=#{template_id}, IS_AFFIX=#{is_affix}, RECORD_ID=#{record_id}, MESSAGE_XML_CONTEXT=#{message_xml_context}, 
      USABLE_STATUS=#{usable_status}, MODIFY_DATE=#{modify_date}, MODIFY_IP=#{modify_ip}, MODIFY_USER_ID=#{modify_user_id}  
      where ID=#{id}
  <xsl:value-of select="$charLt"/>/update>

  <xsl:value-of select="$charLt"/>select id="get" parameterType="string" resultType="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>">
    select 
      <xsl:value-of select="@tableName"/>.ID, <xsl:value-of select="@tableName"/>.BIZ_KEYWORD, <xsl:value-of select="@tableName"/>.SENDER_ID, <xsl:value-of select="@tableName"/>.PARENT_MESSAGE_ID, 
      <xsl:value-of select="@tableName"/>.OWNER_ORG_ID, <xsl:value-of select="@tableName"/>.TEMPLATE_ID, <xsl:value-of select="@tableName"/>.IS_AFFIX, <xsl:value-of select="@tableName"/>.RECORD_ID, 
      <xsl:value-of select="@tableName"/>.MESSAGE_XML_CONTEXT, <xsl:value-of select="@tableName"/>.USABLE_STATUS, <xsl:value-of select="@tableName"/>.MODIFY_DATE, <xsl:value-of select="@tableName"/>.MODIFY_IP, 
      <xsl:value-of select="@tableName"/>.MODIFY_USER_ID
    from <xsl:value-of select="@tableName"/> 
    where <xsl:value-of select="@tableName"/>.ID=#{id}
  <xsl:value-of select="$charLt"/>/select>

  <xsl:value-of select="$charLt"/>select id="getCount" parameterType="string" resultType="int" useCache="true">
    select count(<xsl:value-of select="@tableName"/>.ID) from <xsl:value-of select="@tableName"/>
    <xsl:value-of select="$charLt"/>if test="value != null and value.length > 0">
        where ${value}
    <xsl:value-of select="$charLt"/>/if>
  <xsl:value-of select="$charLt"/>/select>
  
  <xsl:value-of select="$charLt"/>select id="list" parameterType="map" resultType="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>">
    select
      <xsl:value-of select="@tableName"/>.ID, <xsl:value-of select="@tableName"/>.BIZ_KEYWORD, <xsl:value-of select="@tableName"/>.SENDER_ID, <xsl:value-of select="@tableName"/>.PARENT_MESSAGE_ID, 
      <xsl:value-of select="@tableName"/>.OWNER_ORG_ID, <xsl:value-of select="@tableName"/>.TEMPLATE_ID, <xsl:value-of select="@tableName"/>.IS_AFFIX, <xsl:value-of select="@tableName"/>.RECORD_ID
    from <xsl:value-of select="@tableName"/>
    <xsl:value-of select="$charLt"/>if test="queryCondition != null and queryCondition != ''">
        where ${queryCondition}
    <xsl:value-of select="$charLt"/>/if>
    <xsl:value-of select="$charLt"/>if test="orderStr != null and orderStr != ''">
        order by ${orderStr}
    <xsl:value-of select="$charLt"/>/if>
  <xsl:value-of select="$charLt"/>/select>
  
  <xsl:value-of select="$charLt"/>select id="listAllColumn" parameterType="map" resultType="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>">
    select
      <xsl:value-of select="@tableName"/>.ID, <xsl:value-of select="@tableName"/>.BIZ_KEYWORD, <xsl:value-of select="@tableName"/>.SENDER_ID, <xsl:value-of select="@tableName"/>.PARENT_MESSAGE_ID, 
      <xsl:value-of select="@tableName"/>.OWNER_ORG_ID, <xsl:value-of select="@tableName"/>.TEMPLATE_ID, <xsl:value-of select="@tableName"/>.IS_AFFIX, <xsl:value-of select="@tableName"/>.RECORD_ID, 
      <xsl:value-of select="@tableName"/>.MESSAGE_XML_CONTEXT, <xsl:value-of select="@tableName"/>.USABLE_STATUS, <xsl:value-of select="@tableName"/>.MODIFY_DATE, <xsl:value-of select="@tableName"/>.MODIFY_IP, 
      <xsl:value-of select="@tableName"/>.MODIFY_USER_ID
    from <xsl:value-of select="@tableName"/>
    <xsl:value-of select="$charLt"/>if test="queryCondition != null and queryCondition != ''">
        where ${queryCondition}
    <xsl:value-of select="$charLt"/>/if>
    <xsl:value-of select="$charLt"/>if test="orderStr != null and orderStr != ''">
        order by ${orderStr}
    <xsl:value-of select="$charLt"/>/if>
  <xsl:value-of select="$charLt"/>/select>

  <xsl:value-of select="$charLt"/>select id="search" parameterType="map" resultType="<xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>">
    select
      <xsl:value-of select="@tableName"/>.ID, <xsl:value-of select="@tableName"/>.BIZ_KEYWORD, <xsl:value-of select="@tableName"/>.SENDER_ID, <xsl:value-of select="@tableName"/>.PARENT_MESSAGE_ID, 
      <xsl:value-of select="@tableName"/>.OWNER_ORG_ID, <xsl:value-of select="@tableName"/>.TEMPLATE_ID, <xsl:value-of select="@tableName"/>.IS_AFFIX, <xsl:value-of select="@tableName"/>.RECORD_ID, 
      <xsl:value-of select="@tableName"/>.MESSAGE_XML_CONTEXT, <xsl:value-of select="@tableName"/>.USABLE_STATUS, <xsl:value-of select="@tableName"/>.MODIFY_DATE, <xsl:value-of select="@tableName"/>.MODIFY_IP, 
      <xsl:value-of select="@tableName"/>.MODIFY_USER_ID
    from <xsl:value-of select="@tableName"/>
    <xsl:value-of select="$charLt"/>trim prefix="where" prefixOverrides="and|or">  
      <xsl:value-of select="$charLt"/>if test="biz_keyword != null and biz_keyword != ''">
        <xsl:value-of select="@tableName"/>.BIZ_KEYWORD like '%${biz_keyword}%'
      <xsl:value-of select="$charLt"/>/if>
      <xsl:value-of select="$charLt"/>if test="sender_id != null and sender_id != ''">
        and <xsl:value-of select="@tableName"/>.SENDER_ID=#{sender_id}
      <xsl:value-of select="$charLt"/>/if>
      <xsl:value-of select="$charLt"/>if test="parent_message_id != null and parent_message_id != ''">
        and <xsl:value-of select="@tableName"/>.PARENT_MESSAGE_ID=#{parent_message_id}
      <xsl:value-of select="$charLt"/>/if>
      <xsl:value-of select="$charLt"/>if test="owner_org_id != null and owner_org_id != ''">
        and <xsl:value-of select="@tableName"/>.OWNER_ORG_ID=#{owner_org_id}
      <xsl:value-of select="$charLt"/>/if>
      <xsl:value-of select="$charLt"/>if test="template_id != null and template_id != ''">
        and <xsl:value-of select="@tableName"/>.TEMPLATE_ID=#{template_id}
      <xsl:value-of select="$charLt"/>/if>
      <xsl:value-of select="$charLt"/>if test="is_affix != null and is_affix != ''">
        and <xsl:value-of select="@tableName"/>.IS_AFFIX=#{is_affix}
      <xsl:value-of select="$charLt"/>/if>
      <xsl:value-of select="$charLt"/>if test="record_id != null and record_id != ''">
        and <xsl:value-of select="@tableName"/>.RECORD_ID=#{record_id}
      <xsl:value-of select="$charLt"/>/if>
    <xsl:value-of select="$charLt"/>/trim>
    <xsl:value-of select="$charLt"/>if test="orderStr != null and orderStr != ''">
        order by ${orderStr}
    <xsl:value-of select="$charLt"/>/if>
  <xsl:value-of select="$charLt"/>/select>
  
<xsl:value-of select="$charLt"/>/mapper>
	</xsl:template>
	
    <!--处理insert语句的前半部分-->
    <xsl:template match="column" mode="insert_1">
        <xsl:param name="columnName" select="@columnName"/>
        <xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
        <xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
        <xsl:if test="not($columnName=$tablePk)">
            <xsl:choose>
                <xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))">
                    <xsl:value-of select="$columnName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$columnName"/>, </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--处理insert语句的后半部分-->
    <xsl:template match="column" mode="insert_2">
        <xsl:param name="columnName" select="@columnName"/>
        <xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
        <xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
        <xsl:if test="not($columnName=$tablePk)">
            <xsl:choose>
                <xsl:when test="@dataType='java.lang.String'">?</xsl:when>
                <!--标准的jdbc一律为?-->
                <xsl:otherwise>?</xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
                <xsl:otherwise>, </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--处理queryAll语句的循环部分-->
    <xsl:template match="column" mode="queryAll_1">
        <xsl:param name="columnName" select="@columnName"/>
        <xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
        <xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
        <xsl:if test="not($columnName=$tablePk)">
            <xsl:choose>
                <xsl:when test="@dataType='java.lang.String'">
                    <xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
                <xsl:otherwise>, </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--处理queryAll_list语句的循环部分-->
    <xsl:template match="column" mode="queryAll_list">
        <xsl:param name="columnName" select="@columnName"/>
        <xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
        <xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
        <xsl:if test="not($columnName=$tablePk) and @isBuild_list='true'">
            <xsl:choose>
                <xsl:when test="@dataType='java.lang.String'">
                    <xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$tableName"/>.<xsl:value-of select="$columnName"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
                <xsl:when test="@columnName=(../column[@isBuild_list='true'][position()=last()]/@columnName)"/>
                <xsl:otherwise>, </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <!--处理update语句的循环部分-->
    <xsl:template match="column" mode="update_1">
        <xsl:param name="columnName" select="@columnName"/>
        <xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
        <xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
        <xsl:if test="not($columnName=$tablePk)">
            <xsl:choose>
                <xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>
                <xsl:when test="@dataType='java.lang.String'">
                    <xsl:value-of select="concat($columnName,'=?')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($columnName,'=?')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
                <xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>                
                <xsl:otherwise>, </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    
	<!--处理取vo各属性的循环部分-->
	<xsl:template match="column" mode="buildGetCircle">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="@dataType='not_exist_java_data_type'"/>
				<xsl:otherwise>
					<xsl:value-of select="concat('vo.get', str:upperFirst($columnNameFormatLower),'()')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:otherwise>,<xsl:value-of select="$charBr"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--处理取vo各属性的循环部分 update-->
	<xsl:template match="column" mode="buildGetCircle_update">
		<xsl:param name="columnName" select="@columnName"/>
		<xsl:param name="columnNameFormat" select="str:filter(@columnName,@filterKeyword,@filterType)"/>
		<xsl:param name="columnNameFormatLower" select="lower-case($columnNameFormat)"/>
		<xsl:if test="not($columnName=$tablePk)">
			<xsl:choose>
				<xsl:when test="@dataType='not_exist_java_data_type'"/>
				<xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>
				<xsl:otherwise>
					<xsl:value-of select="concat('vo.get', str:upperFirst($columnNameFormatLower),'()')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="position()=last() or (position()=(last()-1) and (../column[position()=last() and @columnName=../@tablePk]))"/>
				<xsl:when test="$columnNameFormatLower='create_date' or $columnNameFormatLower='create_ip' or $columnNameFormatLower='create_user_id' or $columnNameFormatLower='create_user_id_name'"/>
				<xsl:otherwise>,<xsl:value-of select="$charBr"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>