/*
 * 系统名称:Quickbundle.org --> au
 * 
 * 文件名称: com.use.au.tools.test.tree.bs.impl --> XmlHelperTools.java
 * 
 * 功能描述:
 * 
 * 版本历史: 2005-11-19 19:16:49 创建1.0.0版 (baixiaoyong)
 *  
 */
package org.quickbundle.mda.mvm;

import java.io.File;
import java.net.MalformedURLException;
import java.sql.Timestamp;
import java.util.List;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IProgressMonitor;
import org.quickbundle.tools.helper.RmStringHelper;
import org.quickbundle.tools.helper.xml.RmTransformHelper;
import org.quickbundle.tools.helper.xml.RmXmlHelper;

/**
 * 功能、用途、现存BUG:
 * 
 * @author 白小勇
 * @version 1.0.0
 * @see 需要参见的其它类
 * @since 1.0.0
 */
public class CodegenEngine {
	
    public final static String FILE_CONCAT = "/";

    /**
     * mainRule 表示: 规则Document
     */
    private Document mainRule = null;

    /**
     * baseXsltSourcePath 表示: xslt文件的路径, 一般在插件安装目录下
     */
    private String templatePath = null;

    /**
     * baseProjectPath 表示: 生成的目标项目路径,可能在任何目录
     */
    private String baseProjectPath = null;

    /**
     * quickbundleHome 表示: 可能随时改变的rule.xml路径,一般在临时目录下
     */
    private String quickbundleHome = null;
    
    private Document mvmDoc = null;

    /**
     * 构造函数:
     * 
     * @param initXml
     * @param baseXsltSourcePath
     */
    public CodegenEngine(String ruleXml) {
        try {
            this.quickbundleHome = new File(RmXmlHelper.formatToFile(ruleXml)).getParent();
            this.mainRule = RmXmlHelper.parse(ruleXml);
            //初始化java路径
            this.templatePath = RmXmlHelper.formatToUrl(FileLocator.toFileURL(this.getClass().getClassLoader().getResource("template")).toString());
            this.baseProjectPath = RmXmlHelper.formatToUrl(mainRule.getRootElement().valueOf("//rules/codegen//@baseProjectPath"));
            this.mvmDoc = RmXmlHelper.parse(this.templatePath + "/mvm.xml");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getFilterTableName(String currentTableXmlPath) {
        String filterTableName = "";
        currentTableXmlPath = RmXmlHelper.formatToUrl(currentTableXmlPath);
        try {
            //Document thisTableDoc = RmXmlHelper.parse(currentTableXmlPath);
            Document tempResultsDoc = RmTransformHelper.getDocumentFromTransform(templatePath + "buildFilterTableName.xsl", currentTableXmlPath);
            filterTableName = tempResultsDoc.valueOf("/results/result[position()=1]/@tableFormatNameUpperFirst");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return filterTableName;
    }

    public Object[] generateFiles(IProgressMonitor monitor) throws DocumentException, MalformedURLException {
        Object[] aObj = new Object[2];
        int index = 0; //统计文件数
        String returnLog = "";
        String toTableNameKeyword = mainRule.valueOf("/rules/codegen/@toTableNameKeyword");
        List<Element> lTableXmls = mainRule.selectNodes("/rules/database/tableTos/tableTo");
        if(monitor != null) {
            monitor.beginTask("begin generate code......", mainRule.selectNodes(".//file").size() * lTableXmls.size());
        }
        for (Element thisTableTo : lTableXmls) {
            String originalTableName = thisTableTo.getText();
            String currentTableXmlPath = RmXmlHelper.formatToUrl(quickbundleHome + FILE_CONCAT + thisTableTo.valueOf("@xmlName"));
            Document docCurrentTable = RmXmlHelper.parse(currentTableXmlPath);
            String filterTableName = getFilterTableName(currentTableXmlPath);
            String tableDirName = docCurrentTable.valueOf("/meta/tables/table[1]/@tableDirName");
            List<Element> lFile = mvmDoc.selectNodes(".//file");
            for (Element eleFile : lFile) {
                //取出当前rule的组件编码
                String bundleCode = eleFile.valueOf("@bundleCode");
                if(bundleCode != null && bundleCode.length() > 0 && docCurrentTable != null) {
                	String customBundleCode = docCurrentTable.valueOf("/meta/tables/table[@tableName='" + originalTableName + "']/@customBundleCode");
                	//如果定制编码不包含当前rule的组件编码，跳过
                	if(!customBundleCode.matches("^[\\w,]*" + bundleCode + "[\\w,]*$")) {
                		continue;
                	}
                }
                //得到当前这组的基本路径
                String baseTargetPath = getBaseTargetPath(eleFile);
                //得到最终路径
                String xsltPath = templatePath + eleFile.valueOf("@xsltPath");
                String targetPath = eleFile.valueOf("@targetPath");
                if (toTableNameKeyword != null && toTableNameKeyword.length() > 0) { //把TableName替换成表名
                    targetPath = RmStringHelper.replaceFirst(targetPath, toTableNameKeyword, filterTableName);
                }
                if ("java".equals(eleFile.valueOf("../@filesType")) || "jsp".equals(eleFile.valueOf("../@filesType"))) {
                    targetPath = tableDirName + FILE_CONCAT + targetPath;
                } else if ("config".equals(eleFile.valueOf("../@filesType"))) {

                }
                targetPath = baseProjectPath + FILE_CONCAT + baseTargetPath + FILE_CONCAT + targetPath;
                String afterKeyWord = eleFile.valueOf("@afterKeyWord");
                if (afterKeyWord.length() == 0) { //java和jsp文件
                	if("true".equals(eleFile.valueOf("@result-document"))) {
                		XsltHelper.outPutFile4ResultDocument(xsltPath, currentTableXmlPath, targetPath);
                	} else {
                		XsltHelper.outPutFile(xsltPath, currentTableXmlPath, targetPath);
                	}
                } else { //配置文件
                	XsltHelper.outPutFile(xsltPath, currentTableXmlPath, targetPath, afterKeyWord, "true".equals(eleFile.valueOf("@rowIsUnique")));                        
                }
                returnLog += "\r\nxslt模板路径=" + xsltPath + "\r\n表的xml来源" + currentTableXmlPath + "\r\n生成文件的目标路径=" + targetPath + "\r\n位置关键词=" + afterKeyWord + "\r\n\r\n";
                index++;
                if(monitor != null) {
                    monitor.worked(1);
                    String tempStr = null;
                    targetPath = RmXmlHelper.formatToUrlNoPrefix(targetPath);
                    if(targetPath.length() > 75) {
                        tempStr = targetPath.substring(0,12) + "..." + targetPath.substring(targetPath.length()-60);
                    }
                    monitor.setTaskName(tempStr);
                }
            }
        }
        log(returnLog);
        aObj[0] = String.valueOf(index);
        aObj[1] = returnLog;
        return aObj;
    }
    
    private String getBaseTargetPath(Element eleFile) {
    	String baseTargetPath = eleFile.valueOf("../@baseTargetPath");
        if(baseTargetPath == null || baseTargetPath.length() == 0) {
        	String filesType = eleFile.valueOf("../@filesType");
        	String appendPath = eleFile.valueOf("../@appendPath");
        	StringBuilder xpathFiles = new StringBuilder("@filesType='").append(filesType).append("'");
        	if(appendPath != null && appendPath.length() > 0) {
        		xpathFiles.append(" and @appendPath='").append(appendPath).append("'");
        	}
        	baseTargetPath = mainRule.valueOf("/rules/codegen/files[" + appendPath + "]/@baseTargetPath");
        }
        return baseTargetPath;
    }
    
    /**
     * 功能: 写入日志
     * 
     * @param traceMessage
     */
    public void log(String traceMessage) {
        System.out.println("\n" + new Timestamp(System.currentTimeMillis()) + ": " + traceMessage);
    }

    /**
     * 功能: java -jar ranminXmlGenerateCode.jar C:\Docume~1\baixiaoyong\LocalS~1\Temp\ranminXmlGenerateCode\rule***.xml
     *
     * @param args
     */
    public static void main(String[] args) {
        long t = System.currentTimeMillis();
        String rulesXmlPath = null;
        String baseXsltSourcePath = null;
        if (args != null && args.length >= 1) {
            rulesXmlPath = args[0];
            File tempFile = new File(rulesXmlPath);
            baseXsltSourcePath = tempFile.getParent() + "\\";
            System.out.println(baseXsltSourcePath);
        } else {
            System.out.println("usage: java -jar ranminXmlGenerateCode.jar rulesXmlPath!");
            return;
        }
        try {
            CodegenEngine ce = new CodegenEngine(rulesXmlPath);
            Object[] rtObj = ce.generateFiles(null);
            System.out.println("一共生成了" + String.valueOf(rtObj[0]) + "个文件！");
        } catch (Exception e) {
            e.printStackTrace();
        }
        t = System.currentTimeMillis() - t;
        System.out.println("耗时" + t / 1000 + "秒！");
    }
}