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

class M_options extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'options';
	
	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $option_group
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $option_group = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select('id, option_group, option_name, is_deleted');
		$this->db->where('option_group', $option_group);
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('option_name', $keyword);
			$this->db->group_end();
		}
		$this->db->order_by('id', 'ASC');
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table);
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table);
	}

	/**
	 * Get Options
	 * @param String $keyword
	 * @return Array
	 */
	public function get_options($option_group = '') {
		$data = [];
		if (empty($option_group)) {
			return $data;
		}
		$query = $this->db
			->select('id, option_name')
			->where('option_group', $option_group)
			->where('is_deleted', 'false')
			->order_by('id', 'ASC')
			->get(self::$table);
		foreach($query->result() as $row) {
			$data[ $row->id ] = $row->option_name;
		}
		return $data;
	}

	/**
	 * Get option ID
	 * @param String $option_group
	 * @param String $option_name
	 * @return Integer
	 */
	public function get_option_id($option_group = '', $option_name = '') {
		$this->db->select('id');
		$this->db->where('option_group', $option_group);
		$this->db->where('LOWER(option_name)', trim(strtolower($option_name)));
		$this->db->limit(1);
		$query = $this->db->get('options');
		if ($query->num_rows() === 1) {
			$res =  $query->row();
			return $res->id;
		}
		return 0;
	}
}
