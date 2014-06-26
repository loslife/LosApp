package com.yilos.losapp.database;

import java.util.ArrayList;
import java.util.List;

import com.yilos.losapp.AppContext;
import com.yilos.losapp.bean.MemberBean;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/**
 * 
 * 会员数据操作类
 *
 */
public class MemberDBManager {
	private DatabaseHelper helper;  
    private SQLiteDatabase db;  
    private Context context;
      
    public MemberDBManager(Context context) {  
        helper = new DatabaseHelper(context);  
        //因为getWritableDatabase内部调用了mContext.openOrCreateDatabase(mName, 0, mFactory);  
        //所以要确保context已初始化,我们可以把实例化DBManager的步骤放在Activity的onCreate里  
        db = helper.getWritableDatabase();  
        
        this.context = context;
    }  
      
    /** 
     * add member 
     * @param member 
     */  
    public void add(List<MemberBean> memberS) {  
        db.beginTransaction();  //开始事务  
        try {  
        	
            for (MemberBean person : memberS) {  
                db.execSQL("INSERT INTO t_members VALUES(?, ?, ?, ?,?,?,?,?,?,?,?,?)", 
                		new Object[]{person.getId(), 
                		AppContext.getInstance(context).getCurrentDisplayShopId(),
                		person.getName(),
                		person.getBirthday(),
                		person.getPhoneMobile(),
                		person.getJoinDate(),
                		person.getMemberNo(),
                		person.getLatestConsumeTime(),
                		person.getTotalConsume(),
                		person.getAverageConsume(),
                		person.getCreate_date(),
                		person.getModify_date()
                		});  
            }  
            db.setTransactionSuccessful();  //设置事务成功完成  
        } finally {  
            db.endTransaction();    //结束事务  
        }  
    }  
      
    /** 
     * update
     * @param person 
     */  
    public void update(MemberBean person) {  
        ContentValues cv = new ContentValues();  
      
        cv.put("id", person.getId()); 
        cv.put("name", person.getName()); 
        cv.put("enterprise_id", person.getEnterprise_id()); 
        cv.put("create_date", person.getCreate_date());
        cv.put("modify_date", person.getModify_date());
        cv.put("birthday", person.getBirthday());
        cv.put("phoneMobile", person.getPhoneMobile());
        cv.put("joinDate", person.getJoinDate());
        cv.put("memberNo", person.getMemberNo());
        cv.put("latestConsumeTime", person.getLatestConsumeTime());
        cv.put("totalConsume", person.getTotalConsume());
        cv.put("averageConsume", person.getAverageConsume());
        db.update("t_members", cv, "id = ?", new String[]{person.getId()});  
    }  
      
    /** 
     * delete
     * @param person 
     */  
    public void delete(MemberBean person) {  
        db.delete("t_members", "id = ?", new String[]{String.valueOf(person.getId())});  
    }  
      
    /** 
     * query all persons
     * @return List<MemberBean> 
     */  
    public List<MemberBean> query(String eId) {  
        ArrayList<MemberBean> persons = new ArrayList<MemberBean>();  
        Cursor c = queryRecords(eId);  
        while (c.moveToNext()) {  
        	//t_members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32), birthday REAL, 
        	//phoneMobile varchar(16), joinDate REAL, memberNo varchar(32), 
        	//latestConsumeTime REAL, totalConsume REAL, averageConsume REAL, create_date REAL, modify_date REAL);";
        	MemberBean person = new MemberBean();  
            person.setId(c.getString(c.getColumnIndex("id")));  
            person.setName(c.getString(c.getColumnIndex("name")));  
            person.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
            person.setCreate_date(c.getString(c.getColumnIndex("create_date")));
            person.setModify_date(c.getString(c.getColumnIndex("modify_date")));
            
            person.setBirthday(c.getString(c.getColumnIndex("birthday")));
            person.setPhoneMobile(c.getString(c.getColumnIndex("phoneMobile")));
            person.setJoinDate(c.getString(c.getColumnIndex("joinDate")));
            person.setMemberNo(c.getString(c.getColumnIndex("memberNo")));
            person.setLatestConsumeTime(c.getString(c.getColumnIndex("latestConsumeTime")));
            person.setTotalConsume(c.getString(c.getColumnIndex("totalConsume")));
            person.setAverageConsume(c.getString(c.getColumnIndex("averageConsume")));
            
            persons.add(person);  
        }  
        c.close();  
        return persons;  
    } 
    
    /** 
     * query one persons
     * @return List<MemberBean> 
     */  
    public MemberBean queryDetailById(String id) {  
        MemberBean person = new MemberBean();  
        Cursor c = queryDetail(id);  
        while (c.moveToNext()) {  
        	//t_members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32), birthday REAL, 
        	//phoneMobile varchar(16), joinDate REAL, memberNo varchar(32), 
        	//latestConsumeTime REAL, totalConsume REAL, averageConsume REAL, create_date REAL, modify_date REAL);";
  
            person.setId(c.getString(c.getColumnIndex("id")));  
            person.setName(c.getString(c.getColumnIndex("name")));  
            person.setEnterprise_id(c.getString(c.getColumnIndex("enterprise_id")));
            person.setCreate_date(c.getString(c.getColumnIndex("create_date")));
            person.setModify_date(c.getString(c.getColumnIndex("modify_date")));
            
            person.setBirthday(c.getString(c.getColumnIndex("birthday")));
            person.setPhoneMobile(c.getString(c.getColumnIndex("phoneMobile")));
            person.setJoinDate(c.getString(c.getColumnIndex("joinDate")));
            person.setMemberNo(c.getString(c.getColumnIndex("memberNo")));
            person.setLatestConsumeTime(c.getString(c.getColumnIndex("latestConsumeTime")));
            person.setTotalConsume(c.getString(c.getColumnIndex("totalConsume")));
            person.setAverageConsume(c.getString(c.getColumnIndex("averageConsume")));
            
        }  
        c.close();  
        return person;  
    } 
      
    /** 
     * query member
     * @return  Cursor 
     */  
    public Cursor queryRecords(String eid) {  
        Cursor c = db.rawQuery("SELECT * FROM t_members Where enterprise_id = ?", new String[]{eid});
        //Cursor c = db.rawQuery("SELECT * FROM t_members", null);  
        return c;  
    }  
    
    public Cursor queryDetail(String id) {  
        //Cursor c = db.rawQuery("SELECT * FROM t_members Where enterprise_id = ?", new String[]{eid}); 
        Cursor c = db.rawQuery("SELECT * FROM t_members Where id = "+id.trim(), new String[]{id.trim()});  
        return c;  
    }  
      
    /** 
     * close database 
     */  
    public void closeDB() {  
        db.close();  
    }  
}
