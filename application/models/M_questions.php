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

class M_questions extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'questions';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		if ( ! empty($keyword) ) $this->db->like('question', $keyword);
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table);
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table);
	}

	/**
	 * Get Dropdown
	 * @return Array
	 */
	public function dropdown() {
		$this->db->select('id, question');
		$query = $this->db->get(self::$table);
		$data = [];
		foreach($query->result() as $row) {
			$data[$row->id] = $row->question;
		}
		return $data;
	}

	/**
	 * Get Active Question
	 * @return Resource
	 */
	public function get_active_question() {
		return $this->db
			->select('id, question')
			->where('is_active', 'true')
			->where('is_deleted', 'false')
			->limit(1)
			->get(self::$table)
			->row();
	}
}
