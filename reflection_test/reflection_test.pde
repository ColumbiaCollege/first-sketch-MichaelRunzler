import java.lang.reflect.Field;
import java.util.Arrays;

public static int field_01a = 0;
public static String field_02a = "test";
public static File field_03a = new File(System.getProperty("user.home"), "\\Documents\\test.txt");

public static void main(String[] args)
{
  try{
    println(Arrays.toString(getFields(sketch_190116a.class, "field")));
  } catch(IllegalAccessException e){
    e.printStackTrace();
  }
}

protected static String[] getFields(Class target, String filter) throws IllegalAccessException
{
  Field[] fields = target.getDeclaredFields();
  String[] res = new String[fields.length];
  for(int i = 0; i < fields.length; i++){
    Field f = fields[i];
    if(f.getName().contains(filter)) res[i] = String.format("%s | %s", f.getName(), f.get(null).toString());
  }
  
  return res;
}
