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

class M_alumni extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'users';

	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select("
			*
			, COALESCE(LEFT(start_date, 4), '-') year_in
			, COALESCE(LEFT(end_date, 4), '-') year_out
		");
		$this->db->where_in('is_alumni', ['true', 'unverified']);
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('nis', $keyword);
			$this->db->or_like('full_name', $keyword);
			$this->db->or_like('gender', $keyword);
			$this->db->or_like('street_address', $keyword);
			$this->db->or_like('start_date', $keyword);
			$this->db->or_like('end_date', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table);
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table);
	}

	/**
	 * Get Alumni
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_alumni($limit = 0, $offset = 0) {
		$this->db->select("
			*
			, IF(gender = 'M', 'Laki-laki', 'Perempuan') AS gender
			, COALESCE(LEFT(start_date, 4), '-') AS year_in
			, COALESCE(LEFT(end_date, 4), '-') AS year_out
		");
		$this->db->where('is_deleted', 'false');
		$this->db->where('is_alumni', 'true');
		$this->db->order_by('end_date', 'ASC');
		$this->db->order_by('full_name', 'ASC');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table);
	}

	/**
	 * Alumni Reports
	 * @return Resource
	 */
	public function alumni_reports() {
		$this->load->model('m_students');
		$query = $this->m_students->student_query();
		$query .= "
		AND x1.is_alumni='true'
		ORDER BY x1.full_name ASC";
		return $this->db->query($query);
	}
}
