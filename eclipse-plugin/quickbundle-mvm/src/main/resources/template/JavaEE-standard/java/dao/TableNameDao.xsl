<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org">
	<!--导入全局定义-->
	<xsl:import href="../../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:value-of select="str:getJavaFileComment($authorName)"/>
package <xsl:value-of select="$javaPackageTableDir"/>.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.quickbundle.base.beans.factory.RmIdFactory;
import org.quickbundle.third.mybatis.ParaMap;
import org.quickbundle.third.mybatis.RmSqlSessionDaoSupport;
import org.springframework.stereotype.Repository;
import <xsl:value-of select="$javaPackageTableDir"/>.<xsl:value-of select="$ITableNameConstants"/>;
import <xsl:value-of select="$javaPackageTableDir"/>.vo.<xsl:value-of select="$TableNameVo"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>

@Repository
public class <xsl:value-of select="tableFormatNameUpperFirst"/>Dao extends RmSqlSessionDaoSupport implements <xsl:value-of select="$ITableNameConstants"/> {

    /**
     * 插入单条记录，用id作主键
     * 
     * @param vo 用于添加的VO对象
     * @return 若添加成功，返回新生成的id
     */
    public Long insert(<xsl:value-of select="$TableNameVo"/> vo) {
        if(vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>() == null) {
            vo.set<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(RmIdFactory.requestIdLong(TABLE_NAME)); //获得id
        }
        getSqlSession().insert(namespace("insert"), vo);
        return vo.get<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>();
    }

    /**
     * 批更新插入多条记录，用id作主键
     * 
     * @param vos 添加的VO对象数组
     * @return 若添加成功，返回新生成的id数组
     */
    public Long[] insert(<xsl:value-of select="$TableNameVo"/>[] vos) {
        Long[] ids =RmIdFactory.requestIdLong(TABLE_NAME, vos.length); //批量获得id
        for(int i=0; i<xsl:value-of select="$charLt"/>vos.length; i++) {
            vos[i].set<xsl:value-of select="str:upperFirst($tablePkFormatLower)"/>(ids[i]);
        }
        SqlSession session = getSqlSessionTemplate().getSqlSessionFactory().openSession(ExecutorType.BATCH);
        for(<xsl:value-of select="$TableNameVo"/> vo : vos) {
            session.insert(namespace("insert"), vo);
        }
        session.flushStatements();
        return ids;
    }
    
    /**
     * 删除单条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(Long id) {
        return getSqlSession().delete(namespace("delete"), id);
    }

    /**
     * 删除多条记录
     * 
     * @param id 用于删除的记录的id
     * @return 成功删除的记录数
     */
    public int delete(Long ids[]) {
        return getSqlSession().delete(namespace("deleteMulti"), ids);
    }

    /**
     * 更新单条记录
     * 
     * @param vo 用于更新的VO对象
     * @return 成功更新的记录数
     */
    public int update(<xsl:value-of select="$TableNameVo"/> vo) {
        return getSqlSession().update(namespace("update"), vo);
    }

    /**
     * 批量更新修改多条记录
     * 
     * @param vos 添加的VO对象数组
     * @return 成功更新的记录数组
     */
    public int[] update(<xsl:value-of select="$TableNameVo"/>[] vos) {
        int[] result = new int[vos.length];
        SqlSession session = getSqlSessionTemplate().getSqlSessionFactory().openSession(ExecutorType.BATCH);
        int index = 0;
        for(<xsl:value-of select="$TableNameVo"/> vo : vos) {
            result[index++] = session.update(namespace("update"), vo);
        }
        session.flushStatements();
        return result;
    }

    /**
     * 根据Id进行查询
     * 
     * @param id 用于查找的id
     * @return 查询到的VO对象
     */
    public <xsl:value-of select="$TableNameVo"/> get(Long id) {
        return getSqlSession().selectOne(namespace("get"), id);
    }
    
    /**
     * 查询总记录数，带查询条件
     * 
     * @param queryCondition 查询条件
     * @return 总记录数
     */
    public int getCount(String queryCondition) {
        return getSqlSession().selectOne(namespace("getCount"), queryCondition);
    }
    
    /**
     * 功能: 通过组合后的查询条件获得所有的VO对象列表，带翻页，带排序字符
     *
     * @param queryCondition 查询条件, queryCondition等于null或""时查询全部
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @param selectAllClumn 是否查询所有列，即 SELECT * FROM ...(适用于导出)
     * @return 查询到的VO列表
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> list(String queryCondition, String orderStr, int startIndex, int size, boolean allClumn) {
        return getSqlSession().selectList(namespace(allClumn ? "listAllColumn" : "list"), new ParaMap(queryCondition, orderStr), new RowBounds(startIndex-1, size));
    }
    
    /**
     * 功能: 传入查询参数Map，获得所有的VO对象列表，带翻页，带排序字符
     * 
     * @param searchPara 搜索参数的Map
     * @param orderStr 排序字符
     * @param startIndex 开始位置(第一条是1，第二条是2...)
     * @param size 查询多少条记录(size小于等于0时,忽略翻页查询全部)
     * @return
     */
    public List<xsl:value-of select="$charLt"/><xsl:value-of select="$TableNameVo"/>> search(Map<xsl:value-of select="$charLt"/>String, Object> searchPara, String orderStr, int startIndex, int size) {
        searchPara.put("orderStr", orderStr);
        escapeSqlValue(searchPara, new String[]{"biz_keyword"});
        return getSqlSession().selectList(namespace("search"), searchPara, new RowBounds(startIndex-1, size));
    }
}
	</xsl:template>
</xsl:stylesheet>