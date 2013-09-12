package org.quickbundle.third.mybatis.dialect;

public interface Dialect {
	public static enum Type{
		MYSQL,
		ORACLE,
		DB2,
		H2,
		HSQL
	}
	
	public String getLimitString(String sql, int skipResults, int maxResults);
	
}
