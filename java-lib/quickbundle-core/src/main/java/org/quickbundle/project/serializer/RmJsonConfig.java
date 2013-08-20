package org.quickbundle.project.serializer;


public class RmJsonConfig {
//	/**
//	 * 默认的JsonConfig
//	 */
//	private static JsonConfig defaultInstance = new JsonConfig();
//	static {
//		init(defaultInstance);
//	}
//	private static void init(JsonConfig jc){
//		//支持java.sql.Timestamp的转化
//		jc.registerJsonValueProcessor(Timestamp.class, new JsonValueProcessor() {
//			public Object processArrayValue( Object value, JsonConfig jsonConfig ) {
//				return RmStringHelper.prt((Timestamp)value, 19);
//			}
//			public Object processObjectValue( String key, Object value, JsonConfig jsonConfig ) {
//			 	return processArrayValue(value, jsonConfig);
//			}
//		});
//		//支持java.sql.Date的转化
//		jc.registerJsonValueProcessor(Date.class, new JsonValueProcessor() {
//			public Object processArrayValue( Object value, JsonConfig jsonConfig ) {
//				return RmStringHelper.prt((Timestamp)value, 10);   
//			}
//			public Object processObjectValue( String key, Object value, JsonConfig jsonConfig ) {
//			 	return processArrayValue(value, jsonConfig);
//			}
//		});
//		jc.setNewBeanInstanceStrategy(new NewBeanInstanceStrategy() {
//			@Override
//			public Object newInstance(Class target, JSONObject source) throws InstantiationException, IllegalAccessException, SecurityException, NoSuchMethodException, InvocationTargetException {
//				if(target.equals(Timestamp.class)) { //支持java.sql.Timestamp的转化
//					return new Timestamp(System.currentTimeMillis());
//				} else if(target.equals(Date.class)) { //支持java.sql.Date的转化
//					return new Date(System.currentTimeMillis());
//				}  else {
//					return NewBeanInstanceStrategy.DEFAULT.newInstance(target, source);
//				}
//			}
//		});
//		//支持java.sql.Timestamp的转化
//    	JSONUtils.getMorpherRegistry().registerMorpher(new AbstractObjectMorpher() {
//			@Override
//			public Class morphsTo() {
//				return Timestamp.class;
//			}
//			@Override
//			public Object morph(Object value) {
//				return value == null ? null : RmDateHelper.getTimestamp(value.toString());
//			}
//		});
//    	//支持java.sql.Date的转化
//    	JSONUtils.getMorpherRegistry().registerMorpher(new AbstractObjectMorpher() {
//			@Override
//			public Class morphsTo() {
//				return Date.class;
//			}
//			@Override
//			public Object morph(Object value) {
//				return value == null ? null : RmDateHelper.getSqlDate(value.toString());
//			}
//		}); 
//	}
//	public static JsonConfig getDefaultInstance() {
//		return defaultInstance;
//	}
//	
//	public static JsonConfig getNewInstance() {
//		JsonConfig newJc = new JsonConfig();
//		init(newJc);
//		return newJc;
//	}
}