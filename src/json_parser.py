import sys
import json

def main():

	path=sys.argv[1]
	f=open(path,'r')
	data=f.read()
	cust_lst=[]
	clck_lst=[]
	ordr_lst=[]
	for line in data.split('\n'):
		if line!='':
			j_data=json.loads(line)
			print (j_data)
			for j_tmp in j_data:
				if j_tmp['type']=='CUSTOMER':
					cust_lst.append(j_tmp['key'])
					cust_lst.append(j_tmp['last_name']+'|')
					cust_lst.append(j_tmp['adr_city']+'|')
					cust_lst.append(j_tmp['adr_state'])
					cust_lst.append('\n')
				elif j_tmp['type']=='SITE_VISIT' or j_tmp['type']=='IMAGE': 
					clck_lst.append(j_tmp['type']+'|')
					clck_lst.append(j_tmp['customer_id']+'|')
					clck_lst.append(j_tmp['event_time'].replace('T',' ').split('.')[0])
					clck_lst.append('\n')
				elif j_tmp['type']=='ORDER':
					ordr_lst.append(j_tmp['customer_id']+'|')
					ordr_lst.append(j_tmp['event_time'].replace('T',' ').split('.')[0]+'|')
					ordr_lst.append(str(j_tmp['total_amount']).split(' ')[0]+'|')
					ordr_lst.append(j_tmp['total_amount'].split(' ')[1])
					ordr_lst.append('\n')

	fl_nm=path.split('/')[5].split('.')[0]
	w_cust_path='/Users/tonys/PycharmProjects/shutterfly/land/'+fl_nm+'_cust.txt'
	w_clck_path='/Users/tonys/PycharmProjects/shutterfly/land/'+fl_nm+'_clck.txt'
	w_ordr_path='/Users/tonys/PycharmProjects/shutterfly/land/'+fl_nm+'_ordr.txt'
	
	f_w=open(w_cust_path,'w')
	f_w.write(''.join(cust_lst))
	f_w.close()

	f_w=open(w_clck_path,'w')
	f_w.write(''.join(clck_lst))
	f_w.close()

	f_w=open(w_ordr_path,'w')
	f_w.write(''.join(ordr_lst))
	f_w.close()

if __name__=='__main__':
    main()