<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class M_helper extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';
	
	/**
	 *  Insert
	 * @param String $table
	 * @param Array $dataset
	 * @return Boolean
	 */
	public function insert($table = '', $dataset = []) {
		$this->db->trans_start();
		$dataset['created_by'] = __session('user_id');
		$this->db->insert($table, $dataset);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	 * Update
	 * @param Integer $id
	 * @param String $table
	 * @param Array $dataset
	 * @return Boolean
	 */
	public function update($id = 0, $table = '', $dataset = []) {
		$this->db->trans_start();
		$dataset['updated_by'] = __session('user_id');
		$this->db->where(self::$pk, $id)->update($table, $dataset);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	 *  Update Or Insert
	 * @param Integer $id
	 * @param String $table
	 * @param Array $dataset
	 * @return Boolean
	 */
	public function upsert($id = 0, $table = '', $dataset = []) {
		$this->db->trans_start();
		$dataset[(_isNaturalNumber( $id ) ? 'updated_by' : 'created_by')] = __session('user_id');
		_isNaturalNumber( $id ) ?
		 	$this->db->where(self::$pk, $id)->update($table, $dataset) :
			$this->db->insert($table, $dataset);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	* Delete Permanently
	* @param String $key
   * @param String $value
   * @param String $table
	 * @return Boolean
	 */
	public function delete_permanently($key = '', $value = '', $table = '') {
		$this->db->trans_start();
		$this->db->where_in($key, $value)->delete($table);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	 * Delete
	 * @param Array $ids
	 * @param String $table
	 * @return Boolean
	 */
	public function delete($ids = [], $table = '') {
		$this->db->trans_start();
		$this->db->where_in(self::$pk, $ids)
			->update($table, [
				'is_deleted' => 'true',
				'deleted_by' => __session('user_id'),
				'deleted_at' => date('Y-m-d H:i:s')
			]
		);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	 * Truncate Table
	 * @param String $table
	 * @return Boolean
	 */
	public function truncate($table ='') {
		$this->db->trans_start();
		$this->db->truncate($table);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	* Restore
	 * @param Array $ids
	 * @param String $table
	 * @return Boolean
	 */
	public function restore($ids = [], $table = '') {
		$this->db->trans_start();
		$this->db->where_in(self::$pk, $ids)
			->update($table, [
				'is_deleted' => 'false',
				'restored_by' => __session('user_id'),
				'restored_at' => date('Y-m-d H:i:s')
			]
		);
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	* Check value if exists
	* @param String $key
	* @param String $value
	* @param String $table
	 * @return Boolean
	 */
	public function is_exists($key = '', $value = '', $table = '') {
		$count = $this->db
			->where($key, $value)
			->count_all_results($table);
		return $count > 0;
	}

	/**
	 * Row Object
	 * @param String $key
	 * @param String $value
	 * @param String $table
	 * @return Object
	 */
	public function RowObject($key = '', $value = '', $table = '') {
		return $this->db
			->where($key, $value)
			->get($table)
			->row();
	}

	/**
	 * Clear Expired Session and Login Attemps
	 * @return Void
	 */
	public function clear_expired_session(){
		$this->db->query("DELETE FROM `_sessions` WHERE DATE_FORMAT(FROM_UNIXTIME(timestamp), '%Y-%m-%d') < CURRENT_DATE");
		$this->db->query("DELETE FROM `login_attempts` WHERE DATE_FORMAT(created_at, '%Y-%m-%d') < CURRENT_DATE");
	}

	/**
	 * Get Admission Year
	 * @param Integer $admission_year_id
	 * @return Integer
	 */
	public function get_admission_year($admission_year_id = 0) {
		$admission_year = date('Y');
		$query = $this->db
			->select('academic_year')
			->where('id', $admission_year_id)
			->get('academic_years');
		if ($query->num_rows() === 1) {
			$res = $query->row();
			$admission_year = substr($res->academic_year, 0, 4);
		}
		return $admission_year;
	}
}
