<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table[1]">
		<xsl:value-of select="str:getJavaFileComment($authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.dao.<xsl:value-of select="$tableFormatNameUpperFirst"/>Dao;
import <xsl:value-of select="$javaPackageTableDir"/>.dao.<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Dao;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo;
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
import <xsl:value-of select="$javaPackageTableDir"/>.dao.<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Dao;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo;
</xsl:for-each>
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;
import org.quickbundle.project.RmProjectHelper;
import org.quickbundle.project.common.service.IRmCommonService;
import org.quickbundle.tools.helper.RmStringHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

<xsl:value-of select="str:getClassComment($authorName)"/>

@Service
//默认将类中的所有public函数纳入事务管理
@Transactional(readOnly = true)
public class <xsl:value-of select="$tableFormatNameUpperFirst"/>Service implements <xsl:value-of select="$ITableNameConstants"/> {

    @Autowired
    private <xsl:value-of select="$tableFormatNameUpperFirst"/>Dao <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao;
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
    @Autowired
    private <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Dao <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao;
</xsl:for-each>
    /**
     * 插入单条记录
     * 
     * @param vo 用于添加的VO对象
     * @return 若添加成功，返回新生成的Oid
     */
    public Long insert(<xsl:value-of select="$TableNameVo"/> vo) {
        Long id = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.insert(vo);<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        if(vo.getBody<xsl:if test="position()>1">
				<xsl:value-of select="position()"/>
			</xsl:if>() != null) {
            for(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo bodyVo: vo.getBody<xsl:if test="position()>1">
				<xsl:value-of select="position()"/>
			</xsl:if>()) {
                bodyVo.set<xsl:value-of select="str:upperFirst(str:getRefColumnFormatLower(/meta, @tableName))"/> (vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>());
            }
            <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.insert(vo.getBody().toArray(new <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[0]));
        }</xsl:for-each>
        RmProjectHelper.log(LOG_TYPE_NAME, "插入了1条记录,id={}<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">,子记录{}条</xsl:if>", id<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">, vo.getBody() == null ? 0 : vo.getBody().size()</xsl:if>);
        return id;
    }
    
    /**
     * 插入多条记录
     *
     * @param vos 用于添加的VO对象数组
     * @return 返回新生成的id数组
     */
    public Long[] insert(<xsl:value-of select="$TableNameVo"/>[] vos) {
        Long[] ids = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.insert(vos);<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">
			<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        List<xsl:value-of select="$charLt"/>
				<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> bodyVoToInsert<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if> = new ArrayList<xsl:value-of select="$charLt"/>
				<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo>();</xsl:for-each>
        for(<xsl:value-of select="$TableNameVo"/> vo : vos) {<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
            if(vo.getBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>() != null) {
                for(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo bodyVo: vo.getBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>()) {
                    bodyVo.set<xsl:value-of select="str:upperFirst(str:getRefColumnFormatLower(/meta, @tableName))"/> (vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>());
                    bodyVoToInsert<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.add(bodyVo);
                }
            }</xsl:for-each>
        }
        <xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
				<xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.insert(bodyVoToInsert<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.toArray(new <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[0]));</xsl:for-each>
		</xsl:if>
        RmProjectHelper.log(LOG_TYPE_NAME, "插入了{}条记录,id={}<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">,子记录共{}条</xsl:if>", vos.length, Arrays.toString(ids)<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">, <xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">bodyVoToInsert<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.size()<xsl:if test="not(position()=last())"> + </xsl:if>
			</xsl:for-each>
		</xsl:if>);
        return ids;
    }

    /**
     * 删除单条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(Long id) {
        <xsl:value-of select="$TableNameVo"/> vo = get(id);
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        List<xsl:value-of select="$charLt"/>Long> bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if> = new ArrayList<xsl:value-of select="$charLt"/>Long>();
        if(vo.getBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>() != null) {
            for(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo bodyVo : vo.getBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>()) {
                bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.add(bodyVo.get<xsl:value-of select="str:upperFirst(str:getTablePkFormatLower(/meta, @tableName))"/>());
            }
        }
        if(bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.size() > 0) {
            <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.delete(bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.toArray(new Long[0]));
        }
</xsl:for-each>
        int sum = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.delete(id);
        RmProjectHelper.log(LOG_TYPE_NAME, "删除了{}条记录,id={}<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">,子记录共{}条</xsl:if>", sum, id<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">, <xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.size()<xsl:if test="not(position()=last())"> + </xsl:if>
			</xsl:for-each>
		</xsl:if>);
        return sum;
    }

    /**
     * 删除多条记录
     * 
     * @param ids 用于删除的记录的ids
     * @return 成功删除的记录数
     */
    public int delete(Long ids[]) {
<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        List<xsl:value-of select="$charLt"/>Long> bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if> = new ArrayList<xsl:value-of select="$charLt"/>Long>();
</xsl:for-each>
        for(Long id : ids) {
            <xsl:value-of select="$TableNameVo"/> vo = get(id);
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
            if(vo.getBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>() != null) {
                for(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo bodyVo : vo.getBody<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>()) {
                    bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.add(bodyVo.get<xsl:value-of select="str:upperFirst(str:getTablePkFormatLower(/meta, @tableName))"/>());
                }
            }
</xsl:for-each>
        }
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        if(bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.size() > 0) {
            <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.delete(bodyIdToDelete.toArray(new Long[0]));
        }
</xsl:for-each>
</xsl:if>
        int sum = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.delete(ids);
        RmProjectHelper.log(LOG_TYPE_NAME, "删除了{}条记录,ids={}<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">,子记录共{}条</xsl:if>", sum, Arrays.toString(ids)<xsl:if test="count(/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0])>0">, <xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">bodyIdToDelete<xsl:if test="position()>1">
					<xsl:value-of select="position()"/>
				</xsl:if>.size()<xsl:if test="not(position()=last())"> + </xsl:if>
			</xsl:for-each>
		</xsl:if>);
        return sum;
    }

    /**
     * 更新单条记录
     * 
     * @param vo 用于更新的VO对象
     * @return 成功更新的记录数
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public int update(<xsl:value-of select="$TableNameVo"/> vo) {
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        if(vo.getBody() != null) {
            List[] result = mergeVos(vo, <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.list("message_id=" + vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(), null, 1, Integer.MAX_VALUE, true), vo.getBody());
            <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.insert((<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[])result[0].toArray(new <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[0]));
            <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.delete((Long[])result[1].toArray(new Long[0]));
            <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.update((<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[])result[2].toArray(new <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[0]));
        }
</xsl:for-each>
        int sum = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.update(vo);
        RmProjectHelper.log(LOG_TYPE_NAME, "更新了{}条记录,id={}", sum, vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>());
        return sum;
    }

    /**
     * 批量更新修改多条记录
     * 
     * @param vos 更新的VO对象数组
     * @return 成功更新的记录最终数量
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public int update(<xsl:value-of select="$TableNameVo"/>[] vos) {
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> toInsert = new ArrayList<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo>();
        List<xsl:value-of select="$charLt"/>Long> toDelete = new ArrayList<xsl:value-of select="$charLt"/>Long>();
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> toUpdate = new ArrayList<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo>();
        for(<xsl:value-of select="$TableNameVo"/> vo : vos) {
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
            if(vo.getBody() != null) {
                List[] result = mergeVos(vo, <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.list("message_id=" + vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(), null, 1, Integer.MAX_VALUE, true), vo.getBody());
                toInsert.addAll(result[0]);
                toDelete.addAll(result[1]);
                toUpdate.addAll(result[2]);
            }
</xsl:for-each>
        }
        <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.insert(toInsert.toArray(new <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[0]));
        <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.delete(toDelete.toArray(new Long[0]));
        <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.update(toUpdate.toArray(new <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo[0]));
        int[] sum = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.update(vos);
        int finalSum = 0;
        for (int i = 0; i <xsl:value-of select="$charLt"/> sum.length; i++) {
            finalSum += sum[i];
        }
        RmProjectHelper.log(LOG_TYPE_NAME, "批量更新了{}条记录", finalSum);
        return finalSum;
    }
    
    /**
     * 比较老数据集与新数据集，得出insert/delete/update的最优序列
     * 
     * @param vo
     * @param oldVos
     * @param newVos
     * @return
     */
    @SuppressWarnings("rawtypes")
    protected List[] mergeVos(<xsl:value-of select="$TableNameVo"/> headVo, List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> oldVos, List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> newVos) {
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> toInsert = new ArrayList<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo>();
        List<xsl:value-of select="$charLt"/>Long> toDelete = new ArrayList<xsl:value-of select="$charLt"/>Long>();
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> toUpdate = new ArrayList<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo>();
        List[] result = new List[]{toInsert, toDelete, toUpdate};
<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        Map<xsl:value-of select="$charLt"/>Long, <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> oldVoMap = new HashMap<xsl:value-of select="$charLt"/>Long, <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo>();
        for(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo oldVo : oldVos) {
            oldVoMap.put(oldVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(), oldVo);
        }
        for(<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo newVo : newVos) {
            if(newVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() != null <xsl:value-of select="$charAmp"/>
			<xsl:value-of select="$charAmp"/> oldVoMap.containsKey(newVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>())){
                toUpdate.add(newVo);
                oldVoMap.remove(newVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>());
            } else {
                newVo.set<xsl:value-of select="str:upperFirst(str:getRefColumnFormatLower(/meta, @tableName))"/> (headVo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>());
                toInsert.add(newVo);
            }
        }
        for(Map.Entry<xsl:value-of select="$charLt"/>Long, <xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> en : oldVoMap.entrySet()) {
            toDelete.add(en.getKey());
        }
</xsl:for-each>
        return result;
    }

    /**
     * 批量保存，没有主键的insert，有主键的update
     * 
     * @param vos 更新的VO对象数组
     * @return new int[2]{insert的记录数, update的记录数}   
     */
    public int[] insertUpdateBatch(<xsl:value-of select="$TableNameVo"/>[] vos) {
        int[] sum_insert_update = new int[2];
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> lInsert = new ArrayList<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>>();
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> lUpdate = new ArrayList<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>>();
        for (int i = 0; i <xsl:value-of select="$charLt"/> vos.length; i++) {
            if(vos[i].get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() != null) {
                lUpdate.add(vos[i]);
            } else {
                lInsert.add(vos[i]);
            }
        }
        if(lInsert.size() > 0) {
            sum_insert_update[0] = insert(lInsert.toArray(new <xsl:value-of select="$TableNameVo"/>[0])).length;
        }
        if(lUpdate.size() > 0) {
            sum_insert_update[1] = update(lUpdate.toArray(new <xsl:value-of select="$TableNameVo"/>[0]));
        }
        return sum_insert_update;
    }

    /**
     * 根据Id进行查询
     * 
     * @param id 用于查找的id
     * @return 查询到的VO对象
     */
    public <xsl:value-of select="$TableNameVo"/> get(Long id) {
        <xsl:value-of select="$TableNameVo"/> vo = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.get(id);
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> body<xsl:if test="position()>1">
			<xsl:value-of select="position()"/>
		</xsl:if> = <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.list("message_id=" + String.valueOf(id), null, 1, Integer.MAX_VALUE, true);<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        vo.setBody<xsl:if test="position()>1">
				<xsl:value-of select="position()"/>
			</xsl:if>(body);
</xsl:for-each>
        return vo;
    }
    
    /**
     * 查询总记录数，带查询条件
     * 
     * @param queryCondition 查询条件
     * @return 总记录数
     */
    public int getCount(String queryCondition) {
        int sum = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.getCount(queryCondition);
        return sum;
    }

    /**
     * 通过查询条件获得所有的VO对象列表，不带翻页查全部，只查询必要的字段
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字段
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> list(String queryCondition, String orderStr) {
        return list(queryCondition, orderStr, 1, Integer.MAX_VALUE);
    }

    /**
     * 通过查询条件获得所有的VO对象列表，带翻页，带排序字符，只查询必要的字段
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> list(String queryCondition, String orderStr, int startIndex, int size) {
        return list(queryCondition, orderStr, startIndex, size, false);
    }
    
    /**
     * 通过查询条件获得所有的VO对象列表，带翻页，带排序字符，根据selectAllClumn判断是否查询所有字段
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录
     * @param allColumn 是否查询所有列，即 SELECT * FROM ...(适用于导出)
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> list(String queryCondition, String orderStr, int startIndex, int size, boolean allColumn) {
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> lResult = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.list(queryCondition, orderStr, startIndex, size, allColumn);
        if(allColumn) {
            for(<xsl:value-of select="$TableNameVo"/> vo : lResult) {
                List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="str:getTableFormatNameUpperFirst(/meta, @tableName)"/>Vo> body = <xsl:value-of select="str:getTableFormatNameLowerFirst(/meta, @tableName)"/>Dao.list("message_id=" + String.valueOf(vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>()), null, 1, Integer.MAX_VALUE, true);<xsl:for-each select="/meta/relations/mainTable[@tableName=$tableName]/refTable[count(middleTable)=0]">
        vo.setBody<xsl:if test="position()>1">
				<xsl:value-of select="position()"/>
			</xsl:if>(body);
</xsl:for-each>
            }
        }
        return lResult;
    }
    
    /**
     * 按条件搜索，走MyBatis的XML文件的search
     * 
     * @param searchPara 搜索参数的Map
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> search(Map<xsl:value-of select="$charLt"/>String, Object> searchPara, String orderStr, int startIndex, int size) {
        List<xsl:value-of select="$charLt"/>
		<xsl:value-of select="$TableNameVo"/>> lResult = <xsl:value-of select="$tableFormatNameLowerFirst"/>Dao.search(searchPara, orderStr, startIndex, size);
        return lResult;
    }
    
    /**
     * 插入中间表RM_M_MESSAGE_USER数据
     * 
     * @param message_id
     * @param user_ids
     * @return 插入的user_id列表
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public String[] insertRm_m_message_user(String message_id, String[] user_ids) {
        if(user_ids.length == 0 || (user_ids.length == 1 <xsl:value-of select="$charAmp"/>
		<xsl:value-of select="$charAmp"/>user_ids[0].trim().length() == 0)) {
            return new String[0];
        }
        IRmCommonService cs = RmProjectHelper.getCommonServiceInstance();
        List<xsl:value-of select="$charLt"/>String> lExistId = cs.doQuery("select * from RM_M_MESSAGE_USER where MESSAGE_ID=" + message_id + " and USER_ID in(" + RmStringHelper.parseToString(user_ids) + ")", new RowMapper() {
            public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getString("USER_ID");
            }
        });
        Set<xsl:value-of select="$charLt"/>String> sUser_id = new HashSet<xsl:value-of select="$charLt"/>String>();
        for(String user_id : user_ids) {
            if(!lExistId.contains(user_id)) {
                sUser_id.add(user_id);
            }
        }
        if(sUser_id.size() > 0) {
            String[][] aaValue = new String[sUser_id.size()][2];
            int index = 0;
            for (String user_id : sUser_id) {
                aaValue[index][0] = message_id;
                aaValue[index][1] = user_id;
                index ++;
            }
            cs.doUpdateBatch("insert into RM_M_MESSAGE_USER (MESSAGE_ID, USER_ID) VALUES(?, ?)", aaValue);
        }
        return sUser_id.toArray(new String[0]);
    }
    
    /**
     * 删除中间表RM_M_MESSAGE_USER数据
     * 
     * @param message_id
     * @param user_ids
     * @return 删除的记录数
     */
    public int deleteRm_m_message_user(String message_id, String[] user_ids) {
        IRmCommonService cs = RmProjectHelper.getCommonServiceInstance();
        return cs.doUpdate("delete from RM_M_MESSAGE_USER where MESSAGE_ID=" + message_id + " and USER_ID in(" + RmStringHelper.parseToString(user_ids) + ")");
    }
}
</xsl:template>
	<!--生成多对多表Service定义-->
	<xsl:template name="buildMiddleService">
		<xsl:variable name="parentChildTable" select="@parentChildTable"/>
		<xsl:analyze-string select="$parentChildTable" regex=",">
			<xsl:non-matching-substring>
				<xsl:analyze-string select="." regex="^\s*([\w_]+)\.([\w_]+)=([\w_]+)\.([\w_]+)\|([\w_]+)=([\w_]+)\.([\w_]+)\(([\w_]+)\.([\w_]+)\)\s*$">
					<xsl:matching-substring>
    /**
     * 插入中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param <xsl:value-of select="lower-case(regex-group(4))"/>
     * @param <xsl:value-of select="lower-case(regex-group(5))"/>s
     * @return 插入的<xsl:value-of select="lower-case(regex-group(5))"/>列表
     */
    public String[] insert<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(String <xsl:value-of select="lower-case(regex-group(4))"/>, String[] <xsl:value-of select="lower-case(regex-group(5))"/>s) {
        if(<xsl:value-of select="lower-case(regex-group(5))"/>s.length == 0 || (<xsl:value-of select="lower-case(regex-group(5))"/>s.length == 1 <xsl:value-of select="$charAmp"/>
						<xsl:value-of select="$charAmp"/>
						<xsl:value-of select="lower-case(regex-group(5))"/>s[0].trim().length() == 0)) {
            return new String[0];
        }
        IRmCommonService cs = RmProjectHelper.getCommonServiceInstance();
        List<xsl:value-of select="$charLt"/>String> lExistId = cs.doQuery("SELECT * FROM <xsl:value-of select="regex-group(3)"/> WHERE <xsl:value-of select="regex-group(4)"/>=" + <xsl:value-of select="lower-case(regex-group(4))"/> + " AND <xsl:value-of select="regex-group(5)"/> IN(" + RmStringHelper.parseToString(<xsl:value-of select="lower-case(regex-group(5))"/>s) + ")", new RowMapper() {
            public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
                return rs.getString("<xsl:value-of select="regex-group(5)"/>");
            }
        });
        Set<xsl:value-of select="$charLt"/>String> s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/> = new HashSet<xsl:value-of select="$charLt"/>String>();
        for(String <xsl:value-of select="lower-case(regex-group(5))"/> : <xsl:value-of select="lower-case(regex-group(5))"/>s) {
            if(!lExistId.contains(<xsl:value-of select="lower-case(regex-group(5))"/>)) {
                s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.add(<xsl:value-of select="lower-case(regex-group(5))"/>);
            }
        }
        if(s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.size() > 0) {
            String[][] aaValue = new String[s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.size()][2];
            int index = 0;
            for (String <xsl:value-of select="lower-case(regex-group(5))"/> : s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>) {
                aaValue[index][0] = <xsl:value-of select="lower-case(regex-group(4))"/>;
                aaValue[index][1] = <xsl:value-of select="lower-case(regex-group(5))"/>;
                index ++;
            }
            cs.doUpdateBatch("INSERT INTO <xsl:value-of select="regex-group(3)"/> (<xsl:value-of select="regex-group(4)"/>, <xsl:value-of select="regex-group(5)"/>) VALUES(?, ?)", aaValue);
        }
        return s<xsl:value-of select="str:upperFirst(lower-case(regex-group(5)))"/>.toArray(new String[0]);
    }
    
    /**
     * 功能: 删除中间表<xsl:value-of select="regex-group(3)"/>数据
     * 
     * @param <xsl:value-of select="lower-case(regex-group(4))"/>
     * @param <xsl:value-of select="lower-case(regex-group(5))"/>s
     * @return 删除的记录数
     */
    public int delete<xsl:value-of select="str:upperFirst(lower-case(regex-group(3)))"/>(String <xsl:value-of select="lower-case(regex-group(4))"/>, String[] <xsl:value-of select="lower-case(regex-group(5))"/>s) {
        IRmCommonService cs = RmProjectHelper.getCommonServiceInstance();
        return cs.doUpdate("DELETE FROM <xsl:value-of select="regex-group(3)"/> WHERE <xsl:value-of select="regex-group(4)"/>=" + <xsl:value-of select="lower-case(regex-group(4))"/> + " AND <xsl:value-of select="regex-group(5)"/> IN(" + RmStringHelper.parseToString(<xsl:value-of select="lower-case(regex-group(5))"/>s) + ")");
    }
                        </xsl:matching-substring>
				</xsl:analyze-string>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
</xsl:stylesheet>
