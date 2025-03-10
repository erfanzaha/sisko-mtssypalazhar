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

class M_students_scores extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'course_classes';

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
			x1.id
			, x1.academic_year_id
			, x2.academic_year
			, IF(x1.semester = 'odd', 'Ganjil', 'Genap') semester
			, CONCAT(x3.class_group, IF((x4.major_short_name <> ''), CONCAT(' ', x4.major_short_name),''), IF((x3.sub_class_group <> ''), CONCAT(' - ', x3.sub_class_group), '')) AS class_name
			, x5.subject_name
			, x1.is_deleted
		");
		$this->db->join('academic_years x2', 'x1.academic_year_id = x2.id', 'LEFT');
		$this->db->join('class_groups x3', 'x1.class_group_id = x3.id', 'LEFT');
		$this->db->join('majors x4', 'x3.major_id = x4.id', 'LEFT');
		$this->db->join('subjects x5', 'x1.subject_id = x5.id', 'LEFT');
		$this->db->where('x1.employee_id', (int) __session('user_id'));
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x2.academic_year', $keyword);
			$this->db->or_like("CONCAT(x3.class_group, IF((x4.major_short_name <> ''), CONCAT(' ', x4.major_short_name),''), IF((x3.sub_class_group <> ''), CONCAT(' - ', x3.sub_class_group), ''))", $keyword);
			$this->db->or_like('x5.subject_name', $keyword);
			$this->db->group_end();
		}
		$this->db->order_by('x2.academic_year', 'DESC');
		$this->db->order_by('x3.class_group', 'ASC');
		$this->db->order_by('x3.major_id', 'ASC');
		$this->db->order_by('x3.sub_class_group', 'ASC');
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}
}
