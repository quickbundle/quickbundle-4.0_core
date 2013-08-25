package org.quickbundle.mda.template;

import org.quickbundle.tools.helper.xml.RmXmlHelper;

public class JavaTemplateHelper {

    public static String getJavaFileDescComment(String outputFile) {
        StringBuilder result = new StringBuilder();
        result.append("//代码生成时,文件路径: ")
        	.append(RmXmlHelper.formatToUrlNoPrefix(outputFile))
        	.append("\n")
        	.append("//代码生成时,系统时间:")
        	.append(RmXmlHelper.getSysDateTime())
        	.append(", 操作系统用户:")
        	.append(System.getProperty("user.name"))
        	.append("\n\n");
        return result.toString();
    }

    /**
     * 功能: 为xslt创建java文件注释
     * 
     * @param filePathName
     * @param projectName
     * @param authorName
     * @return
     */
    public static String getJavaFileComment(String filePathName, String projectName, String authorName) {
    	StringBuilder result = new StringBuilder();
    	result.append("/*\n")
    		.append(" * 系统名称:单表模板 --> ")
    		.append(projectName)
    		.append("\n")
    		.append(" * \n")
    		.append(" * 文件名称: ")
    		.append(filePathName)
    		.append("\n")
    		.append(" * \n")
    		.append(" * 功能描述:\n")
    		.append(" * \n")
    		.append(" * 版本历史: ")
    		.append(RmXmlHelper.getSysDateTime())
    		.append(" 创建1.0.0版 (")
    		.append(authorName)
    		.append(")\n")
    		.append(" *  \n")
    		.append(" */\n");
        return result.toString();
    }

    /**
     * 功能: 为xslt创建class注释
     * 
     * @param authorName
     * @return
     */
    public static String getClassComment(String authorName) {
    	StringBuilder result = new StringBuilder();
    	result.append("/**\n")
    		.append(" * 功能、用途、现存BUG:\n")
    		.append(" * \n")
    		.append(" * @author " + authorName + "\n")
    		.append(" * @version 1.0.0\n")
    		.append(" * @see 需要参见的其它类\n")
    		.append(" * @since 1.0.0\n")
    		.append(" */\n");
        return result.toString();
    }
    
    /**
     * 功能: 为xslt创建引用子表的html代码
     * 
     * @param authorName
     * @return
     */
    public static String getParentChildHtmlCode(String parentChildTable, String upperFirstTablePk) {
    	StringBuilder sb = new StringBuilder();
    	parentChildTable = parentChildTable.trim();
    	parentChildTable = parentChildTable.replaceAll("[\\s,]+$", "");
    	String[] aStr = parentChildTable.split(",");
    	for (int i = 0; i < aStr.length; i++) {
    		if(aStr[i].trim().length() > 0 && aStr[i].indexOf("=") > -1 && aStr[i].indexOf(".") > -1) {
				String pcr = aStr[i].substring(aStr[i].indexOf("=") + 1).trim();
				String childTableFormatName = pcr.substring(0, pcr.indexOf("."));
				String childFkField = pcr.substring(pcr.indexOf(".")+1, pcr.indexOf("|") > -1 ? pcr.indexOf("|") : pcr.length()).toLowerCase();
				sb.append("new Array ('子表" + childTableFormatName + "','<%=request.getContextPath()%>/" + childTableFormatName + "ConditionAction.do?cmd=queryAll&" + childFkField + "=<%=resultVo.get" + upperFirstTablePk + "()%><%=isReadOnly ? \"&\" + org.quickbundle.project.IGlobalConstants.REQUEST_IS_READ_ONLY + \"=1\" : \"\"%>')");
				if(i < aStr.length-1) {
					sb.append(",\n");
				}
    		}
		}
        return sb.toString();
    }
}
